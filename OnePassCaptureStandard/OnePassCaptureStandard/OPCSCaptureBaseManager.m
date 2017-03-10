//
//  OPCSCaptureBaseManager.m
//  OnePassCaptureStandard
//
//  Created by Soloshcheva Aleksandra on 27.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPCSCaptureBaseManager.h"
#import <OnePassCapture/OnePassCapture.h>

#import "OPCSFaceCaptureLimits.h"
#import "UIImage+Extra.h"

@interface OPCSCaptureBaseManager()

/**
  The instance of AVCaptureSession
 */
@property (nonatomic, strong) AVCaptureSession  *session;

/**
  A serial dispatch queue must be used to guarantee that video frames will be delivered in order.
 */
@property (nonatomic) dispatch_queue_t sessionQueue;

/**
 The 'CIFaceFeature' of the previous frame
 */
@property (nonatomic) CIFaceFeature *previousFace;

/**
 Is the face to be captured
 */
@property (nonatomic) BOOL isCaptured;

/**
 Shows observation of the orientation changing
 */
@property (nonatomic) BOOL isOrientationChangedListener;

/**
 The instance of the capture limit values
 */
@property (nonatomic) OPCSFaceCaptureLimits *captureLimits;

@end

@interface OPCSCaptureBaseManager(PrivateMethods)

/**
 Gets the device front camera

 @return The front camera as the device input
 */
- (AVCaptureDeviceInput *)pickCamera;

/**
 Updates the selected camera
 */
- (void)updateCameraSelection;

/**
 Calculates the brigtness of the frame in the sample buffer

 @param sampleBuffer The buffer with one frame
 */
-(void)calcBrightness:(CMSampleBufferRef)sampleBuffer;

/**
 Analyses the shaking between current and previous frame.
 Calculates the difference between eyes position in these two frame
 */
-(void)calcTremor:(CIFaceFeature *)face;

/**
 Is invoked when the device orientation is changed
 */
-(void)updateOrientation;

/**
 Returns the image size based on the type of device and orienttion

 @return The size of image
 */
-(CGSize)imageSize;

@end

@implementation OPCSCaptureBaseManager

-(void)setIsCaptured:(BOOL)isCaptured{
    _isCaptured = isCaptured;
    if (self.captureLimits) {
        self.captureLimits.isCaptured = _isCaptured;
    }
}

- (void) setupAVCapture
{
    self.captureLimits = [[OPCSFaceCaptureLimits alloc] init];
    
    self.session = [[AVCaptureSession alloc] init];
    
    [self.session setSessionPreset:AVCaptureSessionPreset640x480];
    self.viewForRelay.session = self.session;
    
    [self updateCameraSelection];
    
    self.sessionQueue = dispatch_queue_create( "CaptureDataOutputQueue", DISPATCH_QUEUE_SERIAL );
    
    self.isSingleFace = NO;
    self.isFaceFound  = NO;
    self.isEyesFound  = NO;

    self.isBrightness = NO;
    self.isNoTremor   = NO;
    
    self.videoOutput = [[AVCaptureVideoDataOutput alloc] init];
    self.videoOutput.videoSettings = @{ (NSString *)kCVPixelBufferPixelFormatTypeKey:@(kCMPixelFormat_32BGRA) };
    [self.videoOutput setAlwaysDiscardsLateVideoFrames:YES];
    [self.session addOutput:self.videoOutput];

    // Note that this sets properties for *output*, not preview layer; preview layer has its own capture connection
    AVCaptureConnection *captureConnection = [self.videoOutput connectionWithMediaType: AVMediaTypeVideo];
    captureConnection.enabled = YES;
    captureConnection.videoOrientation = AVCaptureVideoOrientationPortrait;//!!!!Very impotant
    captureConnection.videoMirrored = NO;
    
    self.isOrientationChangedListener = NO;
    
    [self updateOrientation];
//    [self.videoOutput setSampleBufferDelegate:self queue:self.sessionQueue];
}

#pragma mark - IOPCSessionProtocol
///----------------------------------------------------
///  @name  IOPCSessionProtocol
///----------------------------------------------------
-(void)setPreview:(OPCRPreviewView *)preview{
    
    self.viewForRelay = preview;

    // For displaying live feed to screen
    AVCaptureVideoPreviewLayer *previewLayer = (AVCaptureVideoPreviewLayer *)self.viewForRelay.layer;
    [previewLayer setMasksToBounds:YES];
    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [previewLayer setBackgroundColor:[[UIColor whiteColor] CGColor]];
    
    [self setupAVCapture];
}

-(void)startRunning{
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(updateOrientation)
                                               name:UIDeviceOrientationDidChangeNotification
                                             object:nil];
    self.isOrientationChangedListener = YES;
    
    [self.videoOutput setSampleBufferDelegate:self queue:self.sessionQueue];
    self.isCaptured = NO;
    [self.session startRunning];
}

-(void)stopRunning{
    
    [NSNotificationCenter.defaultCenter removeObserver:self
                                                  name:UIDeviceOrientationDidChangeNotification
                                                object:nil];
    self.isOrientationChangedListener = YES;
    
    [self.videoOutput setSampleBufferDelegate:nil queue:nil];
    self.isCaptured = NO;
    [self.session stopRunning];
}

-(BOOL)isRunning{
    return self.session.isRunning;
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection{
    
    [self checkEnviroment:sampleBuffer];
    [self checkPortraitFeatures:sampleBuffer];
    
}

-(void)checkEnviroment:(CMSampleBufferRef)sampleBuffer{
    CFRetain(sampleBuffer);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self calcBrightness:sampleBuffer];
        CFRelease(sampleBuffer);
    });
}


-(void)checkPortraitFeatures:(CMSampleBufferRef)sampleBuffer{
    UIImage *image = [self imageFromSampleBuffer:sampleBuffer];

    UIImage *correctedImage = [[image correctImageOrientation:image] scaledToSize:self.imageSize];
    
//                NSString *photoFolder = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
//                NSString *imagePath = [photoFolder stringByAppendingPathComponent:@"test1.jpeg"];
//                [UIImageJPEGRepresentation(correctedImage, 1) writeToFile:imagePath atomically:YES];
    
    CIImage *ciImage = [CIImage imageWithCGImage:correctedImage.CGImage];
    
    CIDetector* detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                              context:nil
                                              options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];

    NSArray* features = [detector featuresInImage:ciImage options:@{CIDetectorEyeBlink:@YES}];
    
    if (features.count == 1) {
        if(!self.isSingleFace)
            self.isSingleFace = YES;
        
            
        for(CIFaceFeature* faceFeature in features) {
            [self calcTremor:faceFeature];
            if (faceFeature.hasLeftEyePosition && faceFeature.hasRightEyePosition) {
                if (!faceFeature.leftEyeClosed && !faceFeature.rightEyeClosed) {
                    if(!self.isEyesFound) {
                        self.isEyesFound = YES;
                    }
                } else {
                    if(self.isEyesFound) {
                        self.isEyesFound = NO;
                    }
                }
            } else {
                if(self.isEyesFound) {
                    self.isEyesFound = NO;
                }
            }

            if([self.captureLimits checkFace:faceFeature.bounds inScreen:CGRectMake(0, 0, correctedImage.size.width, correctedImage.size.height)]) {
                if(!self.isFaceFound) {
                    self.isFaceFound = YES;
                    self.isCaptured  = YES;
                }
            } else {
                if(self.isFaceFound) {
                    self.isFaceFound = NO;
                }
            }
        }
    }
    else
    {
        if (features.count == 0) {
            if(self.isFaceFound) {
                self.isFaceFound = NO;
            }
            self.previousFace = nil;
        }
            
        if (features.count > 1) {
            if (!self.isFaceFound) {
                if(self.isSingleFace) {
                    self.isSingleFace = NO;
                }
            } else {
                if(self.isSingleFace) {
                    self.isSingleFace = NO;
                }
                self.previousFace = nil;
            }
        }
    }
}

- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    CVImageBufferRef buffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    CVPixelBufferLockBaseAddress(buffer, 0);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef cgContext = CGBitmapContextCreate(CVPixelBufferGetBaseAddress(buffer),
                                                   CVPixelBufferGetWidth(buffer),
                                                   CVPixelBufferGetHeight(buffer),
                                                   8,
                                                   CVPixelBufferGetBytesPerRow(buffer),
                                                   colorSpace,
                                                   kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace);
    
    
    CGImageRef cgImage = CGBitmapContextCreateImage(cgContext);
    UIImage     *image = [UIImage imageWithCGImage:cgImage
                                             scale:1.0f
                                       orientation:UIImageOrientationRight];
    CGImageRelease(cgImage);
    CGContextRelease(cgContext);
    
    CVPixelBufferUnlockBaseAddress(buffer, 0);
    
    return image;
}
@end


@implementation OPCSCaptureBaseManager(PrivateMethods)

- (void) updateCameraSelection
{
    [self.session beginConfiguration];
    
    // have to remove old inputs before we test if we can add a new input
    NSArray* oldInputs = [self.session inputs];
    for (AVCaptureInput *oldInput in oldInputs)
        [self.session removeInput:oldInput];
    
    AVCaptureDeviceInput* input = [self pickCamera];
    if ( ! input ) {
        // failed, restore old inputs
        for (AVCaptureInput *oldInput in oldInputs)
            [self.session addInput:oldInput];
    } else {
        // succeeded, set input and update connection states
        [self.session addInput:input];
        AVCaptureDevice  *device = input.device;
        
        NSError* err;
        if ( ! [device lockForConfiguration:&err] ) {
            NSLog(@"Could not lock device: %@",err);
        }
    }
    
    [self.session commitConfiguration];
}

- (AVCaptureDeviceInput *)pickCamera
{
    AVCaptureDevicePosition desiredPosition = AVCaptureDevicePositionFront;
    BOOL hadError = NO;
    for (AVCaptureDevice *d in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        if ([d position] == desiredPosition) {
            NSError *error = nil;
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:d error:&error];
            if (error) {
                hadError = YES;
                //displayErrorOnMainQueue(error, @"Could not initialize for AVMediaTypeVideo");
            } else if ( [self.session canAddInput:input] ) {
                return input;
            }
        }
    }
    if ( ! hadError ) {
        //displayErrorOnMainQueue(nil, @"No camera found for requested orientation");
    }
    return nil;
}


-(void)calcBrightness:(CMSampleBufferRef)sampleBuffer{

    CFDictionaryRef metadataDict = CMCopyDictionaryOfAttachments( NULL, sampleBuffer, kCMAttachmentMode_ShouldPropagate);
    
    NSDictionary *metadata = [[NSMutableDictionary alloc] initWithDictionary:(__bridge NSDictionary*)metadataDict];
    CFRelease(metadataDict);
    NSDictionary *exifMetadata = [[metadata objectForKey:(NSString *)kCGImagePropertyExifDictionary] mutableCopy];
    float brightnessValue = [[exifMetadata objectForKey:(NSString *)kCGImagePropertyExifBrightnessValue] floatValue];
    if (brightnessValue < 0) {
        if (self.isBrightness) {
            self.isBrightness = NO;
        }
    } else {
        if (!self.isBrightness) {
            self.isBrightness = YES;
        }
    }
}

-(void)calcTremor:(CIFaceFeature *)face
{
    if (self.previousFace) {
        if (face.hasLeftEyePosition && face.hasRightEyePosition) {
            float x = face.bounds.origin.x + face.bounds.size.width/2;
            float y = face.bounds.origin.y + face.bounds.size.height/2;
            
            CGPoint faceCenter = CGPointMake(x, y);
            
            x = self.previousFace.bounds.origin.x + self.previousFace.bounds.size.width/2;
            y = self.previousFace.bounds.origin.y + self.previousFace.bounds.size.height/2;
            
            CGPoint prevFaceCenter = CGPointMake(x, y);
            
            float delta = sqrt(pow(faceCenter.x - prevFaceCenter.x, 2) + pow(faceCenter.y - prevFaceCenter.y, 2));
            
            if (delta > 10) {
                if (self.isNoTremor) {
                    self.isNoTremor = NO;
                }
            } else {
                if (!self.isNoTremor) {
                    self.isNoTremor = YES;
                }
            }
        }
    }
    
    self.previousFace = face;
}

-(void)updateOrientation{
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    
    if ( UIDeviceOrientationIsPortrait( deviceOrientation ) || UIDeviceOrientationIsLandscape( deviceOrientation ) ) {
       self.viewForRelay.videoPreviewLayer.connection.videoOrientation = (AVCaptureVideoOrientation)deviceOrientation;
    }
}

-(CGSize)imageSize{
    return UIDeviceOrientationIsPortrait(UIDevice.currentDevice.orientation) ? CGSizeMake(480, 640) : CGSizeMake(640, 480);
}

@end



//
//  OPCSCaptureBaseManager.m
//  OnePassCaptureStandard
//
//  Created by Soloshcheva Aleksandra on 27.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPCSCaptureBaseManager.h"
#import <OnePassCapture/OnePassCapture.h>
#import <CoreGraphics/CoreGraphics.h>
#import <ImageIO/ImageIO.h>

#import "OPCSFaceManager.h"
#import "CIImage+Extra.h"

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
 The instance of the face manager
 */
@property (nonatomic) id<IOPCCheckFacePosition,IOPCInterfaceOrientationProtocol> faceManager;

@property (nonatomic) CIDetector *detector;
@end

@interface OPCSCaptureBaseManager(PrivateMethods)

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

#warning docs
-(AVCaptureVideoOrientation)videoOrientation;

-(CIImage *)fixOrientation:(CIImage *)ciImage;

@end

@implementation OPCSCaptureBaseManager

- (void) setupAVCapture {
    self.faceManager = [[OPCSFaceManager alloc] init];
    
    self.session = [[AVCaptureSession alloc] init];
    
    [self.session setSessionPreset:AVCaptureSessionPreset640x480];
    self.viewForRelay.session = self.session;
    
    [self setupCaptureDevice];
    
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
    
    self.detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                       context:nil
                                       options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    
}

-(void)setupCaptureDevice{
}


#pragma mark - IOPCSessionProtocol
-(void)setPreview:(id<IOPCPreviewView>)preview {
    
    self.viewForRelay = preview;

    // For displaying live feed to screen
    AVCaptureVideoPreviewLayer *previewLayer = (AVCaptureVideoPreviewLayer *)self.viewForRelay.layer;
    [previewLayer setMasksToBounds:YES];
    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [previewLayer setBackgroundColor:(__bridge CGColorRef _Nullable)([CIColor whiteColor])];
    
    [self setupAVCapture];
}

-(void)startRunning {
    [self.videoOutput setSampleBufferDelegate:self queue:self.sessionQueue];
    [self.session startRunning];
}

-(void)stopRunning {
    [self.videoOutput setSampleBufferDelegate:nil queue:nil];
    [self.session stopRunning];
}

-(BOOL)isRunning {
    return self.session.isRunning;
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection {
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

    @autoreleasepool {
        self.currentImage = [self fixOrientation:[self imageFromSampleBuffer:sampleBuffer]];
        
        NSArray *features = [self.detector featuresInImage:self.currentImage
                                                   options:@{CIDetectorEyeBlink:@YES}];
        
        if (features.count == 1) {
            
            self.isSingleFace = YES;
            
            for(CIFaceFeature* faceFeature in features) {
                [self calcTremor:faceFeature];
                
                if (faceFeature.hasLeftEyePosition && faceFeature.hasRightEyePosition) {
                    
                    self.isEyesFound = (!faceFeature.leftEyeClosed && !faceFeature.rightEyeClosed);
                    
                    self.isFaceFound = [self.faceManager isSuitableFaceByRightEye:faceFeature.rightEyePosition
                                                                        byLeftEye:faceFeature.leftEyePosition
                                                                           inSize:self.currentImage.extent.size];
                } else {
                    self.isEyesFound = NO;
                }
            }
        } else {
            
            if (features.count == 0) {
                self.isFaceFound = NO;
                self.previousFace = nil;
            }
            
            if (features.count > 1) {
                if (!self.isFaceFound) {
                    self.isSingleFace = NO;
                } else {
                    self.isSingleFace = NO;
                    self.previousFace = nil;
                }
            }
        }
    }
}

-(CIImage *)imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer {
    CVImageBufferRef cvImage = CMSampleBufferGetImageBuffer(sampleBuffer);
    return [[CIImage alloc] initWithCVPixelBuffer:cvImage];
}

-(void)setIsFaceFound:(BOOL)isFaceFound {
    if (_isFaceFound != isFaceFound) {
        _isFaceFound = isFaceFound;
    }
}

-(void)setIsEyesFound:(BOOL)isEyesFound {
    if (_isEyesFound != isEyesFound) {
        _isEyesFound = isEyesFound;
    }
}

-(void)setIsSingleFace:(BOOL)isSingleFace{
    if (_isSingleFace != isSingleFace) {
        _isSingleFace = isSingleFace;
    }
}

-(void)setIsNoTremor:(BOOL)isNoTremor {
    if (_isNoTremor != isNoTremor) {
        _isNoTremor = isNoTremor;
    }
}

-(void)setIsBrightness:(BOOL)isBrightness {
    if (_isBrightness != isBrightness) {
        _isBrightness = isBrightness;
    }
}

-(BOOL)isPortraitOrientation{
    return (_interfaceOrientation == OPCAvailableOrientationUp);
}

@end

@implementation OPCSCaptureBaseManager(PrivateMethods)

-(void)calcBrightness:(CMSampleBufferRef)sampleBuffer {
    
    CFDictionaryRef metadataDict = CMCopyDictionaryOfAttachments( NULL, sampleBuffer, kCMAttachmentMode_ShouldPropagate);
    
    NSDictionary *metadata = [[NSMutableDictionary alloc] initWithDictionary:(__bridge NSDictionary*)metadataDict];
    CFRelease(metadataDict);
    NSDictionary *exifMetadata = [[metadata objectForKey:(NSString *)kCGImagePropertyExifDictionary] mutableCopy];
    float brightnessValue = [[exifMetadata objectForKey:(NSString *)kCGImagePropertyExifBrightnessValue] floatValue];
    
    self.isBrightness = (brightnessValue > 0);
}

-(void)calcTremor:(CIFaceFeature *)face {
    if (self.previousFace) {
        if (face.hasLeftEyePosition && face.hasRightEyePosition) {
            float x = face.bounds.origin.x + face.bounds.size.width/2;
            float y = face.bounds.origin.y + face.bounds.size.height/2;
            
            CGPoint faceCenter = CGPointMake(x, y);
            
            x = self.previousFace.bounds.origin.x + self.previousFace.bounds.size.width/2;
            y = self.previousFace.bounds.origin.y + self.previousFace.bounds.size.height/2;
            
            CGPoint prevFaceCenter = CGPointMake(x, y);
            
            float delta = sqrt(pow(faceCenter.x - prevFaceCenter.x, 2) + pow(faceCenter.y - prevFaceCenter.y, 2));
            self.isNoTremor = (delta < 10);
        }
    }
    
    self.previousFace = face;
}

-(void)setInterfaceOrientation:(OPCAvailableOrientation)orientation {
    _interfaceOrientation = orientation;
    
    [self.faceManager setInterfaceOrientation:_interfaceOrientation];
    
    AVCaptureVideoOrientation videoOrientation;
    
    switch (orientation) {
        case OPCAvailableOrientationRight:
            videoOrientation = AVCaptureVideoOrientationLandscapeRight;
            break;
            
        case OPCAvailableOrientationLeft:
            videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
            break;
            
        default:
            videoOrientation = AVCaptureVideoOrientationPortrait;
            break;
    }
    
    self.viewForRelay.videoPreviewLayer.connection.videoOrientation = videoOrientation;
}

-(CIImage *)fixOrientation:(CIImage *)ciImage{

    if (_interfaceOrientation==OPCAvailableOrientationLeft) {
        return [ciImage imageByApplyingOrientation:kCGImagePropertyOrientationLeft];
    }
    
    if (_interfaceOrientation==OPCAvailableOrientationRight) {
        return [ciImage imageByApplyingOrientation:kCGImagePropertyOrientationRight];
    }
    
    return ciImage;
}

-(CGSize)imageSize{
    return (_interfaceOrientation == OPCAvailableOrientationUp) ? CGSizeMake(480, 640) : CGSizeMake(640, 480);
}

-(AVCaptureVideoOrientation)videoOrientation {
    return self.viewForRelay.videoPreviewLayer.connection.videoOrientation;
}

@end



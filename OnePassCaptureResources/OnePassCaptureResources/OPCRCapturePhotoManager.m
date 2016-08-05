//
//  OPCRCaptureVideoManager.m
//  OnePassCaptureResources
//
//  Created by Soloshcheva Aleksandra on 17.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPCRCapturePhotoManager.h"
#import "OPCRFaceView.h"

#import "UIImage+Extra.h"

@interface OPCRCapturePhotoManager()<AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic,strong)  AVCaptureVideoDataOutput *videoOutput;

@property(nonatomic,readwrite) UIImage *image;
@property(nonatomic,readwrite) NSData  *jpeg;

@end

@interface OPCRCapturePhotoManager(PrivateMethods)

- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer;

@end

@implementation OPCRCapturePhotoManager

- (void) setupAVCapture
{
    [super setupAVCapture];

    //For making photo

    self.videoOutput = [[AVCaptureVideoDataOutput alloc] init];
    
    self.videoOutput.videoSettings = @{ (NSString *)kCVPixelBufferPixelFormatTypeKey:@(kCMPixelFormat_32BGRA) };
    
    [self.videoOutput setAlwaysDiscardsLateVideoFrames:YES];
    [self.session addOutput:self.videoOutput];

    // Note that this sets properties for *output*, not preview layer; preview layer has its own capture connection
    AVCaptureConnection *captureConnection = [self.videoOutput connectionWithMediaType: AVMediaTypeVideo];
    captureConnection.enabled = YES;
    captureConnection.videoOrientation = AVCaptureVideoOrientationPortrait;//!!!!Very impotant
    captureConnection.videoMirrored = YES;
    
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate <NSObject>


- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    [self.videoOutput setSampleBufferDelegate:nil queue:nil];
    UIImage *image = [self imageFromSampleBuffer:sampleBuffer];
    
    UIImage *imageToDisplay =
    [UIImage imageWithCGImage:[image CGImage]
                        scale:[image scale]
                  orientation: UIImageOrientationUpMirrored];
   
    self.image = [imageToDisplay scaledToSize:CGSizeMake(240, 320)];
    
    self.jpeg  = UIImageJPEGRepresentation(self.image, 0.9);
    
    return;
}

-(void)update{
 [self.videoOutput setSampleBufferDelegate:self queue:self.sessionQueue];
}

@end

@implementation OPCRCapturePhotoManager(PrivateMethods)

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
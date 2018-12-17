//
//  OPCSCaptureBaseManager.h
//  OnePassCaptureStandard
//
//  Created by Soloshcheva Aleksandra on 27.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <OnePassCapture/OnePassCapture.h>

/**
 The base class for all classes which capture visual resources.
 */
@interface OPCSCaptureBaseManager : NSObject< IOPCSessionProtocol,
                                              IOPCPortraitFeaturesProtocol,
                                              AVCaptureVideoDataOutputSampleBufferDelegate,
                                              IOPCInterfaceOrientationProtocol>

/**
 The unchangeable instance of AVCaptureSession
 */
@property ( nonatomic, strong, readonly)    AVCaptureSession *session;

/**
 Is instance of AVCaptureVideoDataOutput which produce video frames
 */
@property ( nonatomic, strong)     AVCaptureVideoDataOutput *videoOutput;

/**
 The current image in CoreImage format
 */
@property ( nonatomic) CIImage *currentImage;

/**
 The current interface orientation
 */
@property (nonatomic) OPCAvailableOrientation interfaceOrientation;

/**
 Is the view showing the video stream
 */
@property ( nonatomic, weak)       id<IOPCPreviewView> viewForRelay;

/**
 The implementation of 'IOPCPortraitFeaturesProtocol'
 */
@property(nonatomic) BOOL isSingleFace;
@property(nonatomic) BOOL isFaceFound;
@property(nonatomic) BOOL isEyesFound;

/**
 The implementation of 'IOPCEnvironmentProtocol'
 */
@property(nonatomic) BOOL isBrightness;
@property(nonatomic) BOOL isNoTremor;

/**
 Sets up AVCaptureSession
 */
-(void)setupAVCapture;

/**
 Checks the portrait features in the current frame

 @param sampleBuffer The buffer with one frame
 */
-(void)checkPortraitFeatures:(CMSampleBufferRef)sampleBuffer;

/**
 Checks the enviroment in the current frame

 @param sampleBuffer The buffer with one frame
 */
-(void)checkEnviroment:(CMSampleBufferRef)sampleBuffer;

/**
 Converts CMSampleBufferRef to CIImage

 @param sampleBuffer The buffer
 @return The image
 */
- (CIImage *)imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer;

/**
 Is implementation of 'IOPCInterfaceOrientationProtocol'
 */
//-(void)setInterfaceOrientation:(OPCAvailableOrientation)orientation;

/**
 Updates the selected camera
 */
-(void)setupCaptureDevice;

/**
 Fixs the image orientation
 */
-(CIImage *)fixOrientation:(CIImage *)ciImage;

@end

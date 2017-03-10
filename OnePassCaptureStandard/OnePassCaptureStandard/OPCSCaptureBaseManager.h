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
#import <ImageIO/ImageIO.h>

/**
 The base class for all classes which capture visual resources.
 */
@interface OPCSCaptureBaseManager : NSObject<IOPCSessionProtocol,AVCaptureVideoDataOutputSampleBufferDelegate>

/**
 The unchangeable instance of AVCaptureSession
 */
@property (nonatomic,strong,readonly)    AVCaptureSession *session;

/**
 Is instance of AVCaptureVideoDataOutput which produce video frames
 */
@property (nonatomic,strong)     AVCaptureVideoDataOutput *videoOutput;

/**
 Is the view showing the video stream
 */
@property (nonatomic,weak)                OPCRPreviewView *viewForRelay;

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
 Converts CMSampleBufferRef to UIImage

 @param sampleBuffer The buffer
 @return The image
 */
- (UIImage *)imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer;

@end

//
//  OPCRVideoCaptureManager.m
//  OnePassCaptureStandard
//
//  Created by Soloshcheva Aleksandra on 27.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPCSCaptureVideoManager.h"
#import "UIImage+Extra.h"

#import "OPCSVideoConverter.h"

@interface OPCSCaptureVideoManager()<AVCaptureFileOutputRecordingDelegate>

/*
  Implements the complete file recording interface for writing video data.
 */
@property ( nonatomic, strong) AVCaptureMovieFileOutput *movieFileOutput;

/**
 Converts the video data from one format to another one with the acceptable quality
 */
@property ( nonatomic, strong) OPCSVideoConverter       *videoConverter;

/**
 Shows that the recording is in progress
 */
@property (nonatomic) BOOL isRecording;

/**
 The path for video file in NSTemporaryDirectory. The video is written to this file.
 */
@property (nonatomic) NSString      *pathTemporallyFile;

/**
 The path for the compressed video file in NSTemporaryDirectory. The compressed video is written to this file.
 */
@property (nonatomic) NSString      *pathTemporallyCompressedFile;

/**
 The last image taken before the recording starts
 */
@property (nonatomic) UIImage       *lastimage;

/**
 The view that is shown between switching outputs of AVCaptureSession

 @warning It is nessesary because there is a moment when the display turns dark during the outputs switching
 */
@property (nonatomic) UIImageView   *snapshot;

@end

@interface OPCSCaptureVideoManager(PrivateMethods)

/**
 Shows the last image on the device display during the outputs switching
 */
-(void)showSnapshot;

/**
 Hides the last image from the device display
 */
-(void)hideSnapshot;

/**
 The URL of the video

 @return The video URL
 */
-(NSURL *)urlForTemporallyFile;

/**
 Starts compressing the video
 */
-(void)compressVideo;

/**
 Changes the session configuration from the photo recording to the video recording
 */
-(void)changeSessionConfiguration;

@end

@implementation OPCSCaptureVideoManager

-(void)setupAVCapture{
    [super setupAVCapture];
    
    self.isRecording = NO;
}

#pragma mark - IOPCRecordProtocol
-(void)prepare2record{
    if (!self.isRecording) {
        [self showSnapshot];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
            
            [self changeSessionConfiguration];
            
            if (self.ready2RecordBlock) {
                self.ready2RecordBlock(YES);
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self hideSnapshot];
            });
        });
    }
}

#pragma mark - IOPCRecordProtocol
-(void)record{
    if (!self.isRecording) {
        self.isRecording = YES;
        [self.movieFileOutput startRecordingToOutputFileURL:self.urlForTemporallyFile
                                          recordingDelegate:self];
    }
}

-(void)stop{
    if(self.isRecording) {
        [self.movieFileOutput stopRecording];
    }
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection{
    
    [self checkEnviroment:sampleBuffer];
    [self checkPortraitFeatures:sampleBuffer];

    UIImage *image = [self imageFromSampleBuffer:sampleBuffer];
    self.lastimage = [image correctImageOrientation:image];
}

#pragma mark - AVCaptureFileOutputRecordingDelegate
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput
didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL
      fromConnections:(NSArray *)connections
                error:(NSError *)error{
    if(error) {
        if(self.loadDataBlock) {
            self.loadDataBlock(nil,error);
        }
    } else {
        [self compressVideo];
    }
}

@end

@implementation OPCSCaptureVideoManager(PrivateMethods)

-(void)showSnapshot{
    self.snapshot = [[UIImageView alloc] initWithFrame:self.viewForRelay.bounds];
    self.snapshot.contentMode = UIViewContentModeScaleAspectFill;
    self.snapshot.image = [UIImage imageWithCGImage:self.lastimage.CGImage
                                              scale:self.lastimage.scale
                                        orientation:UIImageOrientationUpMirrored];
    
    [self.viewForRelay addSubview:self.snapshot];
}

-(void)hideSnapshot{
    [self.snapshot removeFromSuperview];
    self.snapshot = nil;
}

-(void)reset{
    [self removeTemporallyFile:self.pathTemporallyFile];
    [self removeTemporallyFile:self.pathTemporallyCompressedFile];

    self.videoConverter = nil;
    
    self.pathTemporallyFile = nil;
    self.pathTemporallyCompressedFile = nil;
}

-(NSURL *)urlForTemporallyFile{
    return [NSURL fileURLWithPath:self.tempFilePath];
}

-(NSURL *)urlForCompressedFile{
    return [NSURL fileURLWithPath:self.tempCompressedFilePath];
}

-(NSString *)tempFilePath{
    if(!self.pathTemporallyFile){
        self.pathTemporallyFile = [NSString stringWithFormat:@"%@verify%@.mov", NSTemporaryDirectory(), NSDate.date];
    }
    return self.pathTemporallyFile;
}

-(NSString *)tempCompressedFilePath{
    if (!self.pathTemporallyCompressedFile) {
        self.pathTemporallyCompressedFile = [NSString stringWithFormat:@"%@verifyCompressed%@.mov", NSTemporaryDirectory(), NSDate.date];
    }
    return self.pathTemporallyCompressedFile;
}

-(NSError *)removeTemporallyFile:(NSString *)filename{
    NSError *error;
    [NSFileManager.defaultManager removeItemAtPath:filename error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
    return error;
}

-(void)compressVideo{
    self.videoConverter = [[OPCSVideoConverter alloc] initWithAssetURL:self.urlForTemporallyFile
                                                           toOutputURL:self.urlForCompressedFile];
    
    __weak typeof(self) weakself = self;
    [self.videoConverter exportAsynchronouslyWithCompletionHandler:^(NSError *error) {
        self.isRecording = NO;
        if (error) {
            if (weakself.loadDataBlock) {
                weakself.loadDataBlock(nil,error);
            }
        } else {
            NSData *data = [NSData dataWithContentsOfURL:weakself.urlForCompressedFile];
            [self reset];
            if(data && weakself.loadDataBlock) {
                weakself.loadDataBlock(data,nil);
            }
        }
    }];
}

-(void)changeSessionConfiguration{
    
    [self.session beginConfiguration];
    
    self.movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    
    if ([self.session canAddOutput:self.movieFileOutput]) {
        [self.session addOutput:self.movieFileOutput];
    } else {
        self.loadDataBlock(nil,nil);
    }
    
    AVCaptureConnection *videoConnection = nil;
    
    for ( AVCaptureConnection *connection in [self.movieFileOutput connections] ) {
        for ( AVCaptureInputPort *port in [connection inputPorts] ) {
            if ( [port.mediaType isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
            }
        }
    }
    
    if(videoConnection.isVideoMirroringSupported) {
        videoConnection.videoMirrored = NO;
    }
    
    if(videoConnection.isVideoOrientationSupported) {
        [videoConnection setVideoOrientation:(AVCaptureVideoOrientation)UIDevice.currentDevice.orientation];
    }
    
    AVCaptureDevice      *audioDevice = [AVCaptureDevice      defaultDeviceWithMediaType:AVMediaTypeAudio];
    AVCaptureDeviceInput *audioInput  = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:nil];
    
    if ([self.session canAddInput:audioInput]) {
        [self.session addInput:audioInput];
    }
    
    [self.session commitConfiguration];
}

@end

//
//  OPCRVideoCaptureManager.m
//  OnePassCaptureResources
//
//  Created by Soloshcheva Aleksandra on 27.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPCRCaptureVideoManager.h"
#import "UIImage+FixOrientation.h"

#import "OPCRVideoConverter.h"

@interface OPCRCaptureVideoManager()<AVCaptureFileOutputRecordingDelegate>

@property (nonatomic,strong)   OPCRVideoConverter *videoConverter;
@property (nonatomic, strong)  AVCaptureMovieFileOutput *movieFileOutput;


@property (nonatomic) BOOL isRecording;

@property (nonatomic) NSString *pathTemporallyFile;
@property (nonatomic) NSString *pathTemporallyCompressedFile;


@end

@interface OPCRCaptureVideoManager(PrivateMethods)

-(NSURL *)urlForTemporallyFile;
-(void)compressVideo;

@end

@implementation OPCRCaptureVideoManager


-(void)setupAVCapture{
    [super setupAVCapture];
    
    self.isRecording = NO;
    
    self.movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    
    if ([self.session canAddOutput:self.movieFileOutput])
        [self.session addOutput:self.movieFileOutput];
    else
        self.resultBlock(nil,nil);
    
    AVCaptureConnection *videoConnection = nil;
    
    for ( AVCaptureConnection *connection in [self.movieFileOutput connections] )
    {
        for ( AVCaptureInputPort *port in [connection inputPorts] )
        {
            if ( [[port mediaType] isEqual:AVMediaTypeVideo] )
            {
                videoConnection = connection;
            }
        }
    }
    
    if([videoConnection isVideoMirroringSupported])      videoConnection.videoMirrored = YES;
    
    AVCaptureDevice      *audioDevice = [AVCaptureDevice      defaultDeviceWithMediaType:AVMediaTypeAudio];
    AVCaptureDeviceInput *audioInput  = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:nil];
    
    if ([self.session canAddInput:audioInput])
    {
        [self.session addInput :audioInput];
    }

}



-(void)record
{
    if (!self.isRecording)
    {
        self.isRecording = YES;
        
        [self.movieFileOutput startRecordingToOutputFileURL:[self urlForTemporallyFile]
                                          recordingDelegate:self];
    }
}

-(void)stop
{
    if(self.isRecording)
    {
        [self.movieFileOutput stopRecording];
    }
}

-(UIImage *)thumbnail{
    
    AVURLAsset *urlAssets = [[AVURLAsset alloc] initWithURL:[self urlForTemporallyFile] options:nil];
    
    AVAssetImageGenerator *generate = [[AVAssetImageGenerator alloc] initWithAsset:urlAssets];
    
    NSError *err;
    CMTime time = CMTimeMake(1, 60);
    
    CGImageRef imgRef = [generate copyCGImageAtTime:time actualTime:NULL error:&err];
    
    UIImage *currentImg = [[UIImage alloc] initWithCGImage:imgRef];
    
    currentImg = [UIImage imageWithCGImage:currentImg.CGImage
                                     scale:1.0
                               //orientation:UIImageOrientationRight];
                               orientation:UIImageOrientationLeftMirrored];
    
    return [currentImg fixOrientation];
}

#pragma mark - AVCaptureFileOutputRecordingDelegate

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput
didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL
      fromConnections:(NSArray *)connections
                error:(NSError *)error
{
    if(error)
    {
        if(self.resultBlock)
            self.resultBlock(nil,error);
    }
    else   [self compressVideo];
}


@end

@implementation OPCRCaptureVideoManager(PrivateMethods)

-(void)reset{
    [self removeTemporallyFile:self.pathTemporallyFile];
    [self removeTemporallyFile:self.pathTemporallyCompressedFile];

    self.videoConverter = nil;
    
    self.pathTemporallyFile = nil;
    self.pathTemporallyCompressedFile = nil;
}

-(NSURL *)urlForTemporallyFile
{
    return [NSURL fileURLWithPath:[self tempFilePath]];
 //   return [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/verify%@.mov", NSTemporaryDirectory(),[NSDate date]]];
}

-(NSURL *)urlForCompressedFile{
    return [NSURL fileURLWithPath:[self tempCompressedFilePath]];
    //    return [NSURL fileURLWithPath:[self pathCompressedTemporallyFile]];
}

-(NSString *)tempFilePath
{
    if(!self.pathTemporallyFile){
        self.pathTemporallyFile = [NSString stringWithFormat:@"%@verify%@.mov", NSTemporaryDirectory(),[NSDate date]];
    }
    return self.pathTemporallyFile;
}

-(NSString *)tempCompressedFilePath
{
    if (!self.pathTemporallyCompressedFile) {
        self.pathTemporallyCompressedFile = [NSString stringWithFormat:@"%@verifyCompressed%@.mov", NSTemporaryDirectory(),[NSDate date]];
    }
    return self.pathTemporallyCompressedFile;
}




-(NSError *)removeTemporallyFile:(NSString *)filename
{
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:filename error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
    return error;
}

-(void)compressVideo{
    self.videoConverter = [[OPCRVideoConverter alloc] initWithAssetURL:[self urlForTemporallyFile]
                                                           toOutputURL:[self urlForCompressedFile]];
    __weak typeof(self) weakself = self;
    [self.videoConverter exportAsynchronouslyWithCompletionHandler:^(NSError *error)
    {
        self.isRecording = NO;
        if (error) {
            weakself.resultBlock(nil,error);
        }
        else
        {
            NSData *data = [NSData dataWithContentsOfURL:[weakself urlForCompressedFile]];
            [self reset];
            if(data)
                weakself.resultBlock(data,nil);
            
        }
    }];
}

@end

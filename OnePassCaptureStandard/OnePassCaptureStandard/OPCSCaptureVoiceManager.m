//
//  OPCSCaptureVoiceManager.m
//  OnePassCaptureStandard
//
//  Created by Soloshcheva Aleksandra on 22.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPCSCaptureVoiceManager.h"

#import <AVFoundation/AVFoundation.h>

@interface OPCSCaptureVoiceManager ()<AVAudioRecorderDelegate>

/**
 Controls setting of the audio context.
 */
@property (nonatomic) AVAudioSession   *audioSession;

/**
 Provides audio recording capability.
 */
@property (nonatomic) AVAudioRecorder  *audioRecorder;

@end

@interface OPCSCaptureVoiceManager(PrivateMethods)

/**
 Sets up AVAudioSession
 */
-(void)setupAVAudioSession;

/**
 Sets up AVAudioRecorder
 */
-(void)setupAVAudioRecorder;

/**
 The path for the caf voice file in NSTemporaryDirectory.
 */
-(NSString *)pathCafTemporallyFile;


/**
 Converts the voice file from caf format to wav one

 @param audioFilePath The source file path
 @return The error, if export isn't successful
 */
-(NSError *)convertCaf2WavForFile:(NSString *)audioFilePath;

@end

@implementation OPCSCaptureVoiceManager
///------------------------------------------------
///     @name IOPCRecordProtocol
///------------------------------------------------
-(void)record{
    [self setupAVAudioSession];
    [self setupAVAudioRecorder];
    if ([self.audioRecorder prepareToRecord])
    {
        self.isRecording = YES;
        if([self.audioRecorder record]){
            
        }
    }
}

-(void)stop{
    if (self.audioRecorder.isRecording)
    {
        [self.audioRecorder stop];
    }
}

-(NSTimeInterval)currentTime{
    return self.audioRecorder.currentTime;
}

#pragma mark - AVAudioRecorderDelegate
///------------------------------------------------
///     @name AVAudioRecorderDelegate
///------------------------------------------------
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    NSError *error = [self convertCaf2WavForFile:self.pathCafTemporallyFile];
    if(error)
    {
        self.isRecording = NO;
        self.loadDataBlock(nil,error);
    }
    
    [recorder deleteRecording];
}


- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError * __nullable)error{
    self.isRecording = NO;
    if (self.loadDataBlock)
    {
        self.loadDataBlock(nil,error);
    }
}

@end

@implementation OPCSCaptureVoiceManager(PrivateMethods)

-(void)setupAVAudioSession{
    
    self.isRecording = NO;
    self.audioSession = AVAudioSession.sharedInstance;
    
    NSError *error;
    [self.audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    
    if(error){
        if (self.loadDataBlock)
            self.loadDataBlock(nil,error);
        
        return;
    }
    
    [self.audioSession setActive:YES error:&error];
    
    if(error)
    {
        if (self.loadDataBlock)
            self.loadDataBlock(nil,error);
        return;
    }
    
}

-(void)setupAVAudioRecorder{
    
    if(!self.audioRecorder)
    {
        NSError *error;
        
        self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:[self urlCafTemporallyFile]
                                                         settings:@{         AVFormatIDKey:[NSNumber numberWithInt:kAudioFormatLinearPCM],
                                                                             AVSampleRateKey:@11025,
                                                                             AVLinearPCMBitDepthKey:@16,
                                                                             AVNumberOfChannelsKey:@1,
                                                                             AVLinearPCMIsBigEndianKey:[NSNumber numberWithBool:NO]}
                                                            error:&error];
        
        
        if(error)
        {
            if (self.loadDataBlock)
                self.loadDataBlock(nil,error);
            return;
        }
        self.audioRecorder.delegate = self;
    }
}


-(NSString *)pathCafTemporallyFile
{
    return [NSString stringWithFormat:@"%@voice%lu.caf", NSTemporaryDirectory(), (unsigned long)self.passphraseNumber];
}

-(NSURL *)urlCafTemporallyFile
{
    return [NSURL fileURLWithPath:[self pathCafTemporallyFile]];
}

-(NSString *)pathWavTemporallyFile
{
    return [NSString stringWithFormat:@"%@voice%lu.wav", NSTemporaryDirectory(), (unsigned long)self.passphraseNumber];
}

-(NSURL *)urlWavTemporallyFile
{
    return [NSURL fileURLWithPath:[self pathWavTemporallyFile]];
}

-(NSError *)removeTemporallyFile:(NSString *)filename
{
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:filename error:&error];
    return error;
}

-(NSError *)convertCaf2WavForFile:(NSString*)audioFilePath
{
    NSError *error = nil ;
    
    NSDictionary *audioSetting = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [ NSNumber numberWithFloat:11025.0], AVSampleRateKey,
                                  [ NSNumber numberWithInt:1], AVNumberOfChannelsKey,
                                  [ NSNumber numberWithInt:16], AVLinearPCMBitDepthKey,
                                  [ NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
                                  [ NSNumber numberWithBool:NO], AVLinearPCMIsFloatKey,
                                  [ NSNumber numberWithBool:0], AVLinearPCMIsBigEndianKey,
                                  [ NSNumber numberWithBool:NO], AVLinearPCMIsNonInterleaved,
                                  [ NSData data], AVChannelLayoutKey, nil ];
    
    AVURLAsset *URLAsset = [[AVURLAsset alloc]  initWithURL:[NSURL fileURLWithPath:audioFilePath] options:nil];
    
    AVAssetReader *assetReader = [AVAssetReader assetReaderWithAsset:URLAsset error:&error];
   
    if (error) return error;
    
    NSArray *tracks = [URLAsset tracksWithMediaType:AVMediaTypeAudio];
    if (![tracks count]) return [NSError errorWithDomain:@"com.onepass.captureresource"
                                                    code:400
                                                userInfo:@{ NSLocalizedDescriptionKey: @"no audio trakcs"}];
    
    AVAssetReaderAudioMixOutput *audioMixOutput = [AVAssetReaderAudioMixOutput
                                                   assetReaderAudioMixOutputWithAudioTracks:tracks
                                                   audioSettings :audioSetting];
    
    if (![assetReader canAddOutput:audioMixOutput])
        return assetReader.error;
    [assetReader addOutput :audioMixOutput];
    if (![assetReader startReading])
        return assetReader.error;
  
    [self removeTemporallyFile:[self pathWavTemporallyFile]];
    
    AVAssetWriter *assetWriter = [AVAssetWriter assetWriterWithURL:[self urlWavTemporallyFile]
                                                          fileType:AVFileTypeWAVE
                                                             error:&error];
    
    if (error)
        return error;
    
    AVAssetWriterInput *assetWriterInput = [ AVAssetWriterInput assetWriterInputWithMediaType :AVMediaTypeAudio
                                                                                outputSettings:audioSetting];
    assetWriterInput.expectsMediaDataInRealTime = NO;
    
    if (![assetWriter canAddInput:assetWriterInput])
        return assetWriter.error ;
    [assetWriter addInput :assetWriterInput];
    if (![assetWriter startWriting])
        return assetWriter.error;
    
    [assetWriter startSessionAtSourceTime:kCMTimeZero ];
    
    dispatch_queue_t queue = dispatch_queue_create( "assetWriterQueue", NULL );
    
    [assetWriterInput requestMediaDataWhenReadyOnQueue:queue usingBlock:^{
        @try
        {
            while ([assetWriterInput isReadyForMoreMediaData])
            {
                CMSampleBufferRef sampleBuffer = [audioMixOutput copyNextSampleBuffer];
                if (sampleBuffer)
                {
                    [assetWriterInput appendSampleBuffer :sampleBuffer];
                    CMSampleBufferInvalidate(sampleBuffer);
                    CFRelease(sampleBuffer);
                    sampleBuffer = NULL;
                }
                else
                {
                    [assetWriterInput markAsFinished];
                    [assetReader cancelReading];
                    break;
                }
                
            }
            
            [assetWriter finishWritingWithCompletionHandler:^{
                if(self.isRecording)
                {
                    if(self.loadDataBlock)
                    {
                        self.isRecording = NO;
                        self.loadDataBlock([NSData dataWithContentsOfURL:[self urlWavTemporallyFile]],nil);
                    }
                }
            }];
        }
        @catch (NSException *exception)
        {
            self.isRecording = NO;
            if(self.loadDataBlock)
            {
                self.loadDataBlock(nil,[NSError errorWithDomain:@"com.onepass.captureresource"
                                                           code:400
                                                       userInfo:@{ NSLocalizedDescriptionKey: @"CMSampleBufferRef exeption"}]);
            }
        }
    }];
    
    return nil;
}



@end



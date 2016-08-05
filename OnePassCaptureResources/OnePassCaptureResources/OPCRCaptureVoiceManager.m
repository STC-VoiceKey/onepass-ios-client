//
//  OPCRCaptureVoiceManager.m
//  OnePassCaptureResources
//
//  Created by Soloshcheva Aleksandra on 22.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPCRCaptureVoiceManager.h"

#import <AVFoundation/AVFoundation.h>

@interface OPCRCaptureVoiceManager ()<AVAudioRecorderDelegate>

@property (nonatomic,assign) NSUInteger passphraseNumber;

@property (nonatomic) AVAudioSession   *audioSession;
@property (nonatomic) AVAudioRecorder  *audioRecorder;
@property (nonatomic,copy) LoadVoiceBlock resultBlock;

@end

@interface OPCRCaptureVoiceManager(PrivateMethods)

-(NSString *)pathCafTemporallyFile;
-(NSURL *)urlCafTemporallyFile;

-(NSError *)convertCaf2WavForFile:(NSString*)audioFilePath;

@end

@implementation OPCRCaptureVoiceManager

-(id)initWithPassphraseNumber:(NSUInteger)passphrase withResultBlock:(LoadVoiceBlock)block{
    self = [super init];
    
    if (self) {
        self.passphraseNumber = passphrase;
        self.resultBlock = block;
    }
    
    return self;
}


-(void)setupAVAudioSession{
    self.audioSession = [AVAudioSession sharedInstance];
    
    NSError *error;
    
    [self.audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    
    if(error){
        if (self.resultBlock) self.resultBlock(nil,error);
        return;
    }

    [self.audioSession setActive:YES error:&error];
    
    if(error){
        if (self.resultBlock) self.resultBlock(nil,error);
        return;
    }
    
}

-(void)setupAVAuduoRecorder{
    
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
        if(error){
            if (self.resultBlock) self.resultBlock(nil,error);
            return;
        }
        self.audioRecorder.delegate = self;
        
        
    }
}

-(void)record{
    [self setupAVAudioSession];
    [self setupAVAuduoRecorder];
    if ([self.audioRecorder prepareToRecord]) {
        if([self.audioRecorder record]){
        
        }
    }
}

-(void)stop{
    if (self.audioRecorder.isRecording) {
        [self.audioRecorder stop];
    }
}

#pragma mark - AVAudioRecorderDelegate <NSObject>

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    NSError *error = [self convertCaf2WavForFile:[self pathCafTemporallyFile]];
    if(error)
        self.resultBlock(nil,error);
    
    [recorder deleteRecording];
}


- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError * __nullable)error{
    if (self.resultBlock) self.resultBlock(nil,error);
}

@end

@implementation OPCRCaptureVoiceManager(PrivateMethods)

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
        return assetReader.error ;
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
        @try {
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
                if(self.resultBlock)
                    self.resultBlock([NSData dataWithContentsOfURL:[self urlWavTemporallyFile]],nil);
            }];
        } @catch (NSException *exception) {
            if(self.resultBlock)
                self.resultBlock(nil,[NSError errorWithDomain:@"com.onepass.captureresource"
                                                         code:400
                                                     userInfo:@{ NSLocalizedDescriptionKey: @"CMSampleBufferRef exeption"}]);
        } @finally {
            
        }

    }];
    
    return nil;
}



@end

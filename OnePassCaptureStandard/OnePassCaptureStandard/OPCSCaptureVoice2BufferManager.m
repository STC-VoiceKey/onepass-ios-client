 //
//  OPCSCaptureVoice2BufferManager.m
//  OnePassCaptureStandard
//
//  Created by Soloshcheva Aleksandra on 06.09.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPCSCaptureVoice2BufferManager.h"
#import "OPCSAudioQueueRecorder.h"
#import <AVFoundation/AVFoundation.h>

static NSString *kOnePassLimitNoise = @"kOnePassVoiceNoiseLimit";
static NSString *kVoiceNoiseLimitName = @"VoiceNoiseLimit";

@interface OPCSCaptureVoice2BufferManager()

/**
 Transfers the voice data to be represented in the visual form
 x*/
@property (nonatomic,weak) id<IOPCVoiceVisualizerProtocol> voiceView;

/**
 The reference to the audio queue recorder
 */
@property (nonatomic) OPCSAudioQueueRecorderRef source;

/**
 The buffer for saving up the voice samples
 */
@property (nonatomic) NSMutableData *voiceBuffer;

/**
 Analyses the source of the voice and checks that the passphrase was pronounced
 */
@property (nonatomic) id<IOPCAcousticStopProtocol> stopAnalyzer;

/**
 The passphrase
 */
@property (nonatomic) NSString *passphrase;

/**
 The absolute average value of noise
 */
@property (nonatomic) double lastAbsoluteAverage;

/**
 Is implementation of 'IOPCNoisyProtocol'
 */
@property (nonatomic) BOOL isNoNoisy;

/**
 The threshold of noise
 */
@property (nonatomic) float noiseLimit;

/**
 Shows that the noise analyzer is running
 */
@property (nonatomic) BOOL isNoiseAnalyzerRunning;

@end

@interface OPCSCaptureVoice2BufferManager(PrivateMethods)

/**
 Adds the header of the wav file to the buffer

 @param wav The buffer without header
 @return The buffer with the header
 */
-(NSMutableData *)addWavHeader:(NSData *)wav;

/**
 Adds the voice data from the recorder buffer

 @param recorderRef The reference to the recorder
 @param bufRef The buffer reference
 */
-(void)addData:(OPCSAudioQueueRecorderRef)recorderRef fromBuffer:(AudioQueueBufferRef)bufRef;

@end

/**
 Is the callback function invoked when the audio buffer is full

 @param ref The audio queue recorder reference
 @param audioQueue The audio queue reference
 @param bufRef The audio queue buffer reference
 */
void OPCRRecorderCallback(OPCSAudioQueueRecorderRef ref, AudioQueueRef audioQueue, AudioQueueBufferRef bufRef);

@implementation OPCSCaptureVoice2BufferManager

///-------------------------------------------------------
///     @name   Initialization
///-------------------------------------------------------
-(id)init {
    self = [super init];
    if (self) {
        float noiseLimitFromDefaults = [NSUserDefaults.standardUserDefaults floatForKey:kOnePassLimitNoise];
        if (noiseLimitFromDefaults && noiseLimitFromDefaults>0) {
            self.noiseLimit = noiseLimitFromDefaults;
        } else {
            NSNumber *numberNoiseLimit = [NSBundle.mainBundle objectForInfoDictionaryKey:kVoiceNoiseLimitName];
            self.noiseLimit = [numberNoiseLimit floatValue];
        }
        
        self.isNoiseAnalyzerRunning = NO;
    }
    return self;
}

-(id)initWithAcousticStopAnalyzer:(id<IOPCAcousticStopProtocol>)acousticAnalyzer {
    self = [self init];
    if (self) {
        self.stopAnalyzer = acousticAnalyzer;
    }
    return self;
}

#pragma mark - IOPCNoisyProtocol
///-------------------------------------------------------
///     @name   IOPCNoisyProtocol
///-------------------------------------------------------
-(void)startNoiseAnalyzer {
    @synchronized(self) {
        if(!self.isNoiseAnalyzerRunning) {
            self.lastAbsoluteAverage = 0;
            self.isNoNoisy = YES;
            self.isNoiseAnalyzerRunning = YES;
            self.source = OPCRAudioQueueSourceCreate(OPCRRecorderCallback, (__bridge void *)(self));
            OPCSAudioQueueSourceStartRecord(self.source);
        }
        
    }
}

-(void)stopNoiseAnalyzer {
    @synchronized(self) {
        if(self.isNoiseAnalyzerRunning) {
            self.isNoNoisy = YES;
            self.isNoiseAnalyzerRunning = NO;
            OPCSAudioQueueSourceStopRecord(self.source);
        }
    }
}
#pragma mark - IOPCRecordProtocol
///-------------------------------------------------------
///     @name   IOPCRecordProtocol
///-------------------------------------------------------
-(void)record {
    @synchronized(self) {
        if(self.isRecording) {
            if (self.loadDataBlock) {
                self.loadDataBlock(nil,[NSError errorWithDomain:@"com.onepass.captureresource"
                                                           code:400
                                                       userInfo:@{ NSLocalizedDescriptionKey: @"Record is running exeption"}]);
            }
            return;
        }
    }

    self.voiceBuffer = [[NSMutableData alloc] init];
    
    self.isRecording = YES;
    
    self.source = OPCRAudioQueueSourceCreate(OPCRRecorderCallback,(__bridge void *)self);
    OPCSAudioQueueSourceStartRecord(self.source);
    
    if (self.stopAnalyzer) {
        [self.stopAnalyzer startWithPassphrase:self.passphrase];
    }
}

-(void)stop {
    @synchronized(self) {
        
        if(self.isRecording) {
            self.isRecording = NO;
            
            OPCSAudioQueueSourceStopRecord(self.source);
            
            if (self.loadDataBlock) {
                self.loadDataBlock([self addWavHeader:self.voiceBuffer],nil);
            }
            
            if (self.stopAnalyzer) {
                [self.stopAnalyzer stopListening];
            }
        }
    }
}

-(NSTimeInterval)currentTime {
    return (self.isRecording) ? OPCSSourceGetCurrentTime(self.source) : 0;
}

-(void)dealloc {
    _voiceBuffer = nil;
}



#pragma mark - IOPCIsVoiceVisualizerProtocol
///--------------------------------------------
///     @name   IOPCIsVoiceVisualizerProtocol
///--------------------------------------------

-(void)setPreview:(id<IOPCVoiceVisualizerProtocol>)preview {
    self.voiceView = preview;
}

@end

@implementation OPCSCaptureVoice2BufferManager(PrivateMethods)

-(NSMutableData *)addWavHeader:(NSData *)wav {
    NSMutableData *wavHeader = [[NSMutableData alloc] init];
    
    NSUInteger sampleRate = 11025;
    NSUInteger bps = 16;
    
    NSUInteger numChannels = 1;
    NSUInteger byteRate = sampleRate * numChannels * (bps/8);
    NSUInteger blockAlign = numChannels * (bps/8);
    
    [wavHeader appendBytes:"RIFF" length:4]; // 0x52, 0x49, 0x46, 0x46, whole file is RIFF chunk
    [wavHeader appendBytes: (uint64_t[]){ (uint64_t)(36 + wav.length) } length: 4]; // RIFF chunk size (== WAVE subchunk + data chunk)
    [wavHeader appendBytes:"WAVE" length:4];// 0x57, 0x41, 0x56, 0x45, WAVE chunk
    [wavHeader appendBytes:"fmt " length:4];// 0x66, 0x6D, 0x74, 0x20, fmt subchunk of WAVE chunk
    
    [wavHeader appendBytes: (uint64_t[]){ (uint64_t)(16) } length: 4]; // 0x10, 0x00, 0x00, 0x00, fmt subchunk size (16 for PCM)
    [wavHeader appendBytes: (uint64_t[]){ (uint64_t)(1) }  length: 2]; // 0x01, 0x00, PCM format
    [wavHeader appendBytes: (uint64_t[]){ (uint64_t)(numChannels) } length: 2];
    [wavHeader appendBytes: (uint64_t[]){ (uint64_t)(sampleRate)  } length: 4];
    [wavHeader appendBytes: (uint64_t[]){ (uint64_t)(byteRate) } length: 4];
    [wavHeader appendBytes: (uint64_t[]){ (uint64_t)(blockAlign) } length: 2];
    [wavHeader appendBytes: (uint64_t[]){ (uint64_t)(bps) } length:2 ];// end of fmt subchunk
    
    [wavHeader appendBytes:"data" length:4];
    [wavHeader appendBytes: (uint64_t[]){ (uint64_t)(wav.length) } length:4 ];
    
    [wavHeader appendData:wav];
    
    return wavHeader;
}

-(void)addData:(OPCSAudioQueueRecorderRef)recorderRef fromBuffer:(AudioQueueBufferRef)bufRef{
    
    if(self.isRecording) {
        @synchronized (self) {
            [self.voiceBuffer appendBytes: bufRef->mAudioData length: bufRef->mAudioDataByteSize];
            
            if (self.stopAnalyzer && self.isRecording) {
                if([self.stopAnalyzer isSayingFinished:bufRef->mAudioData length:bufRef->mAudioDataByteSize]) {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                        
                        NSLog(@"acoustic stop");
                        [self stop];
                    });
                }
            }
            
            if(self.voiceView && self.isRecording) {
                [self.voiceView visualizeVoiceBuffer:bufRef->mAudioData length:bufRef->mAudioDataByteSize];
            }
        }
    } else {
        double absoluteAverage = self.lastAbsoluteAverage;
        int i = 0;
        for ( short *pointer = (short *)bufRef->mAudioData; i < (bufRef->mAudioDataByteSize / 2) ; pointer++, i++) {
            absoluteAverage = absoluteAverage*0.9998 +  (double)abs(*pointer) * 0.0002;
        }
        self.noiseValue = [NSNumber numberWithFloat:absoluteAverage];
        self.lastAbsoluteAverage = absoluteAverage;
        
        if([self.noiseValue floatValue] < self.noiseLimit) {
            if (!self.isNoNoisy) {
                self.isNoNoisy = YES;
            }
        } else {
            if (self.isNoNoisy) {
                self.isNoNoisy = NO;
            }
        }
    }
}

@end

void OPCRRecorderCallback(OPCSAudioQueueRecorderRef ref, AudioQueueRef audioQueue, AudioQueueBufferRef bufRef) {
    
    if (ref && ref->userInfo)
    {
        OPCSCaptureVoice2BufferManager* manager = (__bridge OPCSCaptureVoice2BufferManager*)ref->userInfo;
        if(ref->queue != audioQueue) return;
        
        [manager addData:ref fromBuffer:bufRef];
    }
}

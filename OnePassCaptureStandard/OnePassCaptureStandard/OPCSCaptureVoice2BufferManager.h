//
//  OPCSCaptureVoice2BufferManager.h
//  OnePassCaptureStandard
//
//  Created by Soloshcheva Aleksandra on 06.09.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OnePassCapture/OnePassCapture.h>
#import "OPCSCaptureBaseManager.h"

/**
 Provides the voice resource.
 Writes the voice data into a buffer.
 */
@interface OPCSCaptureVoice2BufferManager :  NSObject<IOPCCaptureVoiceManagerProtocol,IOPCNoisyProtocol,IOPCIsVoiceVisualizerProtocol>

///------------------------------------------------
///     @name     Initialization
///------------------------------------------------
/**
 Is implementation of 'IOPCLoadingDataProtocol'
 @param acousticAnalyzer The instance of 'IOPCAcousticStopProtocol'
 @return The voice capture manager
 */
-(id)initWithAcousticStopAnalyzer:(id<IOPCAcousticStopProtocol>)acousticAnalyzer;

/**
 Is implementation of 'IOPCLoadingDataProtocol'
 */
@property(nonatomic)       NSUInteger *passphraseNumber;

/**
 Is implementation of 'IOPCLoadingDataProtocol'
 */
@property (nonatomic,copy) LoadDataBlock loadDataBlock;

/**
 Is implementation of 'IOPCRecordProtocol'
 */
@property(nonatomic) BOOL isRecording;
-(void)record;
-(void)stop;

/**
 Is implementation of 'IOPCNoisyProtocol'
 */
@property(nonatomic) NSNumber *noiseValue;

/**
 Is implementation of 'IOPCVoiceVisualizerProtocol'
 */
-(void)setPreview:(id<IOPCVoiceVisualizerProtocol>)preview;

@end

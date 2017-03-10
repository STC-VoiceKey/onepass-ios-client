//
//  OPCSCaptureVoiceManager.h
//  OnePassCaptureStandard
//
//  Created by Soloshcheva Aleksandra on 22.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OnePassCapture/OnePassCapture.h>
#import "OPCSCaptureBaseManager.h"

/**
 Provides the voice resource.
 Writes the voice data into a file.
 */
@interface OPCSCaptureVoiceManager : NSObject<IOPCCaptureVoiceManagerProtocol>

/**
 Is implementation of 'IOPCLoadingDataProtocol'
 */
@property(nonatomic) NSUInteger *passphraseNumber;

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

@end

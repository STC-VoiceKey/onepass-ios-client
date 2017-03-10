//
//  IOPCSCaptureVoiceManagerProtocol.h
//  OnePassCaptureStandard
//
//  Created by Soloshcheva Aleksandra on 08.08.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IOPCRecordProtocol.h"
#import "IOPCLoadingDataProtocol.h"
#import "IOPCVoiceProtocol.h"
#import "IOPCAcousticStopProtocol.h"

/**
 The 'IOPCSCaptureVoiceManagerProtocol' provides the photo resource.
 Includes three protocols
    The 'IOPCRecordProtocol' controls the proccess of audio recording
    The 'IOPCLoadingDataProtocol' transfers the received data to the recipient
    The 'IOPCVoiceProtocol' provides a passphrase for which the voice will be recorded
 */
@protocol IOPCCaptureVoiceManagerProtocol <IOPCRecordProtocol,
                                      IOPCLoadingDataProtocol,
                                            IOPCVoiceProtocol>

@optional

/**
 If the voice manager can provide sources of voice then acoustic stop can be used

 @param acousticAnalyzer The instance of 'IOPCAcousticStopProtocol'
 @return The newly-initialized voice capture manager
 */
-(id)initWithAcousticStopAnalyzer:(id<IOPCAcousticStopProtocol>)acousticAnalyzer;

/**
 Transfers the passphrase

 @param passphrase The passphrase
 */
-(void)setPassphrase:(NSString *)passphrase;

/**
 The current average volume of sound

 @return The average volume fo sound
 */
-(NSNumber *)noiseValue;

@end

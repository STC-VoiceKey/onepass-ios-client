//
//  IOPCCaptureVideoManagerProtocol.h
//  OnePassCaptureStandard
//
//  Created by Soloshcheva Aleksandra on 08.08.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IOPCRecordProtocol.h"
#import "IOPCLoadingDataProtocol.h"
#import "IOPCSessionProtocol.h"
#import "IOPCPortraitFeaturesProtocol.h"
#import "IOPCEnvironmentProtocol.h"

/**
 Is the block which is called when the manager is ready to start recording
 
 @param status YES, if the manager is ready to record
 */
typedef void (^Ready2RecordBlock) ( BOOL status);

/**
 The 'IOPCCaptureVideoManagerProtocol' provides the video resource.
 Includes five protocols
    The 'IOPCRecordProtocol' controls the proccess of video recording
    The 'IOPCPortraitFeaturesProtocol' checks portrait features before the recording, if all portrait features and environments are valid, it raises the ready to record block
    The 'IOPCEnvironmentProtocol' checks enviroments before the recording, if all portrait features and environments are valid, it raises the ready to record block
    The 'IOPCLoadingDataProtocol' transfers the received data to the recipient
    The 'IOPCSessionProtocol' controls the AVSession instance for video stream displaying
 */
@protocol IOPCCaptureVideoManagerProtocol <IOPCRecordProtocol,
                                 IOPCPortraitFeaturesProtocol,
                                      IOPCEnvironmentProtocol,
                                      IOPCLoadingDataProtocol,
                                          IOPCSessionProtocol>

/**
 Setter for 'Ready2RecordBlock' block
 @param block The block is raised in 'prepare2record'
 */
-(void)setReady2RecordBlock:(Ready2RecordBlock)block;

/**
 Getter for 'Ready2RecordBlock' block
 @return The 'Ready2RecordBlock' block
 */
-(Ready2RecordBlock)ready2RecordBlock;

@end

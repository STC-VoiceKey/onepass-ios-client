//
//  IOPCRecordProtocol.h
//  OnePassCaptureStandard
//
//  Created by Soloshcheva Aleksandra on 08.08.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 The 'IOPCRecordProtocol' manages a process of recording
 */
@protocol IOPCRecordProtocol <NSObject>

@required

/**
 Shows the state of the recorder

 @return YES, if the recording is in progress
 */
-(BOOL)isRecording;

/**
 Starts recording
 */
-(void)record;

/**
 Stops recording
 */
-(void)stop;

@optional

/**
 The method is called when the manager is ready to record
 */
-(void)prepare2record;

/**
 Returns a current recording timestamp

 @return The current timestamp
 */
-(NSTimeInterval)currentTime;

@end

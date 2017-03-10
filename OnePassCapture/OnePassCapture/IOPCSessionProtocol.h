//
//  IOPCSessionProtocol.h
//  OnePassCaptureStandard
//
//  Created by Soloshcheva Aleksandra on 09.08.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OnePassCapture/OnePassCapture.h>

/**
 The 'IOPCSessionProtocol' manages the video session
 */
@protocol IOPCSessionProtocol <NSObject>

@required

/**
 Sets a view which shows the video stream

 @param preview The preview view
 */
-(void)setPreview:(OPCRPreviewView *)preview;

/**
  Runs a video session instance.
 */
-(void)startRunning;

/**
 Stops a video session instance.
 */
-(void)stopRunning;

/**
 Indicates whether the session is currently running.

 @return YES, is the session running currently
 */
-(BOOL)isRunning;


@end

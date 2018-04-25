//
//  IOPCPreviewView.h
//  OnePassCapture
//
//  Created by Soloshcheva Aleksandra on 01.06.17.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

/**
 The view that shows the video stream from AVCaptureSession
 */
@protocol IOPCPreviewView <NSObject>

@required

/**
 The session video stream of which is shown in the view
 */
-(AVCaptureSession *)session;
-(void)setSession:(AVCaptureSession *)session;

/**
 The layer subclass for previewing the visual output of an AVCaptureSession
 */
-(AVCaptureVideoPreviewLayer *)videoPreviewLayer;

/**
 The core animation layer of preview view
 */
-(CALayer *)layer;

@end

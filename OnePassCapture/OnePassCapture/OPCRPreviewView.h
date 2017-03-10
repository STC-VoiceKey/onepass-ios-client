//
//  OPCRPreviewView.h
//  OnePassCaptureStandard
//
//  Created by Soloshcheva Aleksandra on 17.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

/**
 The view that shows the video stream from AVCaptureSession
 */
@interface OPCRPreviewView : UIView

/**
 The session video stream of which is shown in the view
 */
@property (strong,nonatomic) AVCaptureSession *session;

/**
 The layer subclass for previewing the visual output of an AVCaptureSession
 */
@property (readonly,nonatomic) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@end

//
//  OPCRPreviewView.h
//  OnePassCaptureStandard
//
//  Created by Soloshcheva Aleksandra on 17.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import <OnePassCapture/OnePassCapture.h>

/**
 The view that shows the video stream from AVCaptureSession
 */
@interface OPCRPreviewView : UIView<IOPCPreviewView>


@end

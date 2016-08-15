//
//  OPCRPreviewView.h
//  OnePassCaptureResources
//
//  Created by Soloshcheva Aleksandra on 17.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface OPCRPreviewView : UIView

@property (strong,nonatomic) AVCaptureSession* session;

-(void)failBorder;
-(void)successBorder;
//-(void)suspenseBorder;

@end

//
//  OPCRCaptureManager.h
//  OnePassCaptureResources
//
//  Created by Soloshcheva Aleksandra on 27.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class OPCRPreviewView;

@interface OPCRCaptureManager : NSObject

@property (nonatomic,strong,readonly)  AVCaptureSession *session;
@property (nonatomic,readonly) dispatch_queue_t sessionQueue;

@property (nonatomic,readonly,getter=readyForCapture) BOOL isReady;

-(id)initWithView:(OPCRPreviewView *)view;

-(void)setupAVCapture;

-(void)startRunning;
-(void)stopRunning;

-(void)update;

@end

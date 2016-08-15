//
//  OPCRCaptureBaseManager.h
//  OnePassCaptureResources
//
//  Created by Soloshcheva Aleksandra on 27.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <OnePassUICommon/OnePassUICommon.h>

@class OPCRPreviewView;

@interface OPCRCaptureBaseManager : NSObject

@property (nonatomic,weak) OPCRPreviewView *viewForRelay;

@property (nonatomic,strong,readonly)  AVCaptureSession *session;
@property (nonatomic,readonly) dispatch_queue_t sessionQueue;

@property (nonatomic,readonly,getter=readyForCapture) BOOL isReady;

-(void)setupAVCapture;

-(void)setPreview:(OPCRPreviewView *)preview;

-(void)startRunning;
-(void)stopRunning;

-(void)update;
-(void)setupIsReady:(BOOL)isReady;

@end

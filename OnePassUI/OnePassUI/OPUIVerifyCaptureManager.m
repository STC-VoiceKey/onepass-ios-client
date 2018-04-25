//
//  OPUIVerifyCaptureManager.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 28.12.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPUIVerifyCaptureManager.h"

@interface OPUIVerifyCaptureManager()

/**
 Is the block which is called when data is received
 */
@property (nonatomic) ResponceBlock callerBlock;

@end

@implementation OPUIVerifyCaptureManager

#pragma mark - IOPCSessionProtocol
-(void)setPreview:(id<IOPCPreviewView>)preview{
    if (self.videoCaptureManager) {
        [self.videoCaptureManager setPreview:preview];
    }
}

-(BOOL)isRunning{
    return self.isRunning;
}

-(void)startRunning{
    [self.videoCaptureManager startRunning];
}

-(void)stopRunning{
    [self.videoCaptureManager stopRunning];
}

#pragma mark - IOPCRecordProtocol
-(void)record{
    if (![self.videoCaptureManager isRecording]) {
        [self.videoCaptureManager record];
    }
}

-(void)stop{
    if ([self.videoCaptureManager isRecording]) {
        [self.videoCaptureManager stop];
    }
}

-(BOOL)isRecording{
    return [self.videoCaptureManager isRecording];
}

-(void)prepare2record{
    [self.videoCaptureManager prepare2record];
}

-(void)setResponceBlock:(ResponceBlock)responceBlock{
    
    self.callerBlock = responceBlock ;
    
    __weak typeof(self) weakself = self;
    
    if (responceBlock) {
        self.videoCaptureManager.loadDataBlock = ^(NSData *data, NSError *error){
            if (error) {
                if (weakself.callerBlock) {
                    weakself.callerBlock(nil,error);
                }
                return;
            }
            
            if (weakself.callerBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakself.activityIndicator startAnimating];
                });
                
                [weakself.videoCaptureManager stop];
                [weakself.videoCaptureManager stopRunning];
                
#ifdef DEBUG
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *verifyPath =  [[paths objectAtIndex:0] stringByAppendingPathComponent:@"verify.mov"];
                [data writeToFile:verifyPath atomically:YES];
#endif
            
                if(weakself.service && weakself.session) {

                    [weakself.service addVerificationVideo:data
                                            withPassphrase:weakself.session.passphrase
                                       withCompletionBlock:^(NSDictionary *responceObject, NSError *error) {
                                           if (weakself.callerBlock) {
                                               weakself.callerBlock(responceObject,error);
                                           }
                                       }];
                }
            }
        };
    } else {
        self.videoCaptureManager.loadDataBlock = nil;
    }
}

@end

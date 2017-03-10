//
//  OPUIBlockTimer.m
//  OnePassCapture
//
//  Created by Soloshcheva Aleksandra on 20.09.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPUIBlockCentisecondsTimer.h"

@interface OPUIBlockCentisecondsTimer()

@property (nonatomic) float millisecond;

@end

@implementation OPUIBlockCentisecondsTimer

-(id)initTimerWithProgressBlock:(TimerBlock)progressBlock
                withResultBlock:(TimerBlock)resultBlock{
    self = [super init];
    if (self) {
        self.progress = progressBlock;
        self.result   = resultBlock;
    }
    return self;
}

-(void)startWithTime:(float)millisecond{
    self.millisecond = millisecond;
    
    [self createBlockWithTime:self.millisecond/10
            withTimeInterval:100*NSEC_PER_MSEC];
    
    self.block(0);
}


-(void)createBlockWithTime:(float)time
         withTimeInterval:(NSTimeInterval)timeInterval{
    __weak typeof(self) weakself = self;
    self.block = ^(float i) {
        if (weakself.progress) {
            weakself.progress(i);
        }
        if (i < time) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, timeInterval), dispatch_get_main_queue(), ^(void){
                if(weakself.block) {
                    weakself.block(i+1);
                }
            });
        } else {
            weakself.block = nil;
            if (weakself.result) {
                weakself.result(0);
            }
        }
    };
}

-(BOOL)isProcessing{
    return (self.block != nil);
}

-(void)stop{
    self.block = nil;
}

@end



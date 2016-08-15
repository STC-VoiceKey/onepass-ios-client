//
//  OPUIBlockTimer.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 19.07.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPUIBlockSecondTimer.h"

typedef void (^TimerSecondBlock)(float seconds);

@interface OPUIBlockSecondTimer()

@property (nonatomic) float seconds;
@property (nonatomic) TimerBlock progress;
@property (nonatomic) TimerBlock result;

@property (nonatomic) TimerBlock block;

@end

@implementation OPUIBlockSecondTimer

-(id)initTimerWithProgressBlock:(TimerBlock)progressBlock
       withResultBlock:(TimerBlock)resultBlock{
    
    self = [super init];
    
    if (self) {
        self.progress = progressBlock;
        self.result   = resultBlock;
        
    }
    
    return self;
}

-(void)startWithTime:(float)seconds{
    
    self.seconds = seconds;
    
    __weak OPUIBlockSecondTimer *weakself = self;
    
    self.block = ^(float i){
        if (weakself.progress)
            weakself.progress(i);
        if (i < weakself.seconds) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1*NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
                if(weakself.block) weakself.block(i+1);
            });
        }else
        {
            weakself.block = nil;
            if (weakself.result) {
                weakself.result(0);
            }
        }
    };
    self.block(0);
}

-(void)stop{
    self.block = nil;
}

@end

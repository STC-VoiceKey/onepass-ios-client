//
//  OPUIVerifyShowFaceHelperTimer.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 15.11.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import "OPUIVerifyShowFaceHelperTimer.h"
#import "OPUIBlockSecondTimer.h"

@interface OPUIVerifyShowFaceHelperTimer()

@property (nonatomic) OPUIBlockSecondTimer *timer;
@property (nonatomic) HelperTimerHandler handler;

@end

@implementation OPUIVerifyShowFaceHelperTimer

- (id)initWithHandler:(HelperTimerHandler)handler {
    self = [super init];
    if (self) {
        self.handler = handler;
        __weak typeof(self) weakself = self;
        self.timer = [[OPUIBlockSecondTimer alloc] initTimerWithProgressBlock:nil
                                                              withResultBlock:^(float secund) {
                                                                  if (weakself.handler) {
                                                                      weakself.handler();
                                                                  }   
                                                              }];
    }
    return self;
}

-(BOOL)isProcessing{
    return [self.timer isProcessing];
}

- (void)start {
    if(![self.timer isProcessing]) {
        [self.timer startWithTime:2];
    }
}

- (void)stop {
     [self.timer stop];
}

-(void)reset {
    self.handler = nil;
    [self.timer stop];
}

@end

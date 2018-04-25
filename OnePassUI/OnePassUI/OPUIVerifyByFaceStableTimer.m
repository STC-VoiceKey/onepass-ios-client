//
//  OPUIVerifyByFaceHalperTimer.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 15.11.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import "OPUIVerifyByFaceHalperTimer.h"
#import "OPUIBlockSecondTimer.h"

@interface OPUIVerifyByFaceHalperTimer()

@property (nonatomic) StableTimerHandler handler;
@property (nonatomic) OPUIBlockSecondTimer  *faceNoFoundTimer;

@end

@implementation OPUIVerifyByFaceHalperTimer

- (id)initWithHandler:(StableTimerHandler)handler {
    self = [self init];
    if (self) {
        self.handler = handler;
        self.faceNoFoundTimer = [[OPUIBlockSecondTimer alloc] initTimerWithProgressBlock:nil
                                                                         withResultBlock:^(float second) {
                                                                             self.handler();
                                                                         }];    }
    return self;
}

- (void)restart {
    [self.faceNoFoundTimer stop];
    [self.faceNoFoundTimer startWithTime:2];
}

- (void)start {
   [self.faceNoFoundTimer startWithTime:2];
}

- (void)stop {
     [self.faceNoFoundTimer stop];
}

@end

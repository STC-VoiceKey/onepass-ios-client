//
//  OPUIVoiceLimitTimer.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 14.11.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import "OPUILimitTimer.h"
#import "OPUIBlockCentisecondsTimer.h"

static NSString *kVoiceCaptureTimeoutName = @"VoiceCaptureTimeout";

@interface OPUILimitTimer()

/**
 The value of the voice duration
 */
@property (nonatomic) NSNumber    *timeout;

/**
 The timer that fires when the voice should be finished
 */
@property (nonatomic) OPUIBlockCentisecondsTimer *voiceLimitDurationTimer;

@property (nonatomic) id<OPUIProgressViewProtocol> view;

@property (nonatomic) TimerHandler handler;

@end

@implementation OPUILimitTimer

- (id)initWithView:(id<OPUIProgressViewProtocol>)view withHandler:(TimerHandler)handler{
    self = [super init];
    if (self) {
        self.view = view;
        self.handler = handler;
        [self configureTimer];
    }
    return self;
}

- (void)start {
    [self.voiceLimitDurationTimer startWithTime:self.timeout.floatValue];
}

- (void)stop {
    [self.voiceLimitDurationTimer stop];
}

-(void)configureTimer {
    __weak typeof(self) weakself = self;
    self.voiceLimitDurationTimer = [[OPUIBlockCentisecondsTimer alloc] initTimerWithProgressBlock:^(float seconds){
        [weakself.view showProgress:(seconds * 10/weakself.timeout.floatValue)];
    }
                                                                                  withResultBlock:^(float seconds)
                                    {
                                        [self.view showProgress:0];
                                        self.handler();
                                    }];
}

-(NSNumber *)timeout {
    NSNumber *value = [NSBundle.mainBundle objectForInfoDictionaryKey:kVoiceCaptureTimeoutName];
    return @(100*value.floatValue);
}

@end


//
//  OPUIVerifyLimitTimer.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 29.11.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import "OPUIVerifyLimitTimer.h"


static NSString *kVideoCaptureTimeoutName    = @"VideoCaptureTimeout";

@implementation OPUIVerifyLimitTimer

-(NSNumber *)timeout {
    NSNumber *value = [NSBundle.mainBundle objectForInfoDictionaryKey:kVideoCaptureTimeoutName];
    return @(100*value.floatValue);
}


@end

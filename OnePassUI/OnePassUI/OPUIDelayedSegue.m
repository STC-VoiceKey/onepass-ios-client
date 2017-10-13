//
//  OPUIDelayedSegue.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 03.11.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPUIDelayedSegue.h"

static const NSTimeInterval kPerformDelay = 0.5;

@implementation OPUIDelayedSegue

-(void)perform {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kPerformDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [super perform];
    });
}
@end

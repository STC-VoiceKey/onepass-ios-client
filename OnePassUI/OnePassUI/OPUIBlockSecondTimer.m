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

@end

@implementation OPUIBlockSecondTimer

-(void)startWithTime:(float)value{
    self.seconds = value;
    
    [self createBlockWithTime:self.seconds
             withTimeInterval:1*NSEC_PER_SEC];

    self.block(0);
}


@end

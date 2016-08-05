//
//  OPUIBlockTimer.h
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 19.07.16.
//  Copyright © 2016 Soloshcheva Aleksandra. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^TimerBlock)(float);

@interface OPUIBlockSecondTimer : NSObject

-(id)initTimerWithProgressBlock:(TimerBlock)progressBlock
       withResultBlock:(TimerBlock)resultBlock;

-(void)startWithTime:(float)seconds;
-(void)stop;

@end

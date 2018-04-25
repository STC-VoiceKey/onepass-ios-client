//
//  OPUIVoiceLimitTimer.h
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 14.11.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OPUIProgressViewProtocol.h"

typedef void (^TimerHandler) (void);

@protocol OPUIVoiceLimitTimerProtocol

-(id)initWithView:(id<OPUIProgressViewProtocol>)view withHandler:(TimerHandler)handler;

-(void)start;
-(void)stop;

-(NSNumber *)timeout;

@end

@interface OPUILimitTimer : NSObject<OPUIVoiceLimitTimerProtocol>


@end

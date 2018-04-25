//
//  OPUIVerifyShowFaceHelperTimer.h
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 15.11.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^HelperTimerHandler) (void);

@protocol OPUIVerifyShowFaceHelperTimerProtocol

-(id)initWithHandler:(HelperTimerHandler)handler;

-(BOOL)isProcessing;

-(void)start;
-(void)stop;
-(void)reset;

@end

@interface OPUIVerifyShowFaceHelperTimer : NSObject<OPUIVerifyShowFaceHelperTimerProtocol>

@end

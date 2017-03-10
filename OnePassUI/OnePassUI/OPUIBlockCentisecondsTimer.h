//
//  OPUIBlockTimer.h
//  OnePassCapture
//
//  Created by Soloshcheva Aleksandra on 20.09.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 The timer block type definition

 @param float The current time
 */
typedef void (^TimerBlock)(float);

/**
 The block centisecond timer
 */
@interface OPUIBlockCentisecondsTimer : NSObject

/**
 The block which is called periodically while the timer is in rogress
 */
@property (nonatomic) TimerBlock progress;

/**
 The block which is called when the timer is fired
 */
@property (nonatomic) TimerBlock result;

/**
 The checking timer block
 */
@property (nonatomic) TimerBlock block;

/**
 The newly-initialized block timer

 @param progressBlock The progress block
 @param resultBlock The result block
 @return The newly-initialized block timer
 */
-(id)initTimerWithProgressBlock:(TimerBlock)progressBlock
                withResultBlock:(TimerBlock)resultBlock;


/**
 Starts the timer with duration

 @param value The duration of timer
 */
-(void)startWithTime:(float)value;

/**
 Stops the timer
 */
-(void)stop;

/**
 Shows that the timer is running

 @return YES, if the timer is running
 */
-(BOOL)isProcessing;

/**
 Creates the checking timer block which is running during the time and calls the progress block each time interval

 @param time The timer time
 @param timeInterval The progress block time interval
 */
-(void)createBlockWithTime:(float)time
          withTimeInterval:(NSTimeInterval)timeInterval;

@end

//
//  OPUI3QuarterArcView.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 01.11.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPUI3QuarterArcView.h"
#import "UIView+DrawShapes.h"

static float stage = 0;
static const float kStageCount = 20.0;
static const NSTimeInterval kTimeInterval = 0.15;

extern const float kLineWidth;

@interface OPUI3QuarterArcView()

/**
 The repeating timer
 */
@property (nonatomic, strong) NSTimer *timer;

@end

@interface OPUI3QuarterArcView(PrivateMethods)

/**
 Starts the timer and adds it on the current run loop
 */
-(void)startTimerOnRunLoop;

@end

@implementation OPUI3QuarterArcView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self startTimerOnRunLoop];
    }
    return self;
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:(NSCoder *)aDecoder];
    if (self) {
        [self startTimerOnRunLoop];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, self.tintColor.CGColor);
    
    CGPoint centerPoint = CGPointMake(self.bounds.size.width/2.0f, self.bounds.size.height/2.0f - self.radius);
    
    CGFloat radius = self.finisning ? 1.4*self.radius : self.radius;
    
    if (!self.finisning) {
        float startAngle = 2.0f*M_PI*(stage/kStageCount);
        [self drawArcInCenter:centerPoint withStartAngle:startAngle withEndAngle:(startAngle + 0.75*M_PI) withRadius:radius inContext:context];
    } else {
        if(self.showFail) {
            [self drawCircleInCenter:centerPoint withRadius:radius inContext:context];
        }
    }
    
    CGContextSetBlendMode(context, kCGBlendModeClear);
    [self drawCircleInCenter:centerPoint withRadius:(radius - kLineWidth) inContext:context];
    
    if (self.finisning) {
        CGContextSetBlendMode(context, kCGBlendModeColor);
        
        if (self.showFail) {
            if(self.fail) {
                [self drawCrossInCenter:centerPoint withRadius:radius inContext:context];
            } else {
                [self drawMarkerInCenter:centerPoint withRadius:radius inContext:context];
            }
        }
    }
    
    stage++;
    stage = (stage == kStageCount) ? 0 : stage;
}

-(void)removeFromSuperview{
    [super removeFromSuperview];
    
    [self.timer invalidate];
}

@end

@implementation OPUI3QuarterArcView(PrivateMethods)

-(void)startTimerOnRunLoop{
    self.timer = [NSTimer timerWithTimeInterval:kTimeInterval
                                         target:self
                                       selector:@selector(setNeedsDisplay)
                                       userInfo:nil
                                        repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    self.finisning = NO;
}

@end

//
//  OPUICircleProgressView.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 01.11.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPUICircleProgressView.h"
#import "UIView+DrawShapes.h"

@implementation OPUICircleProgressView

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGPoint centerPoint = CGPointMake(self.bounds.size.width/2.0f, self.bounds.size.height/2.0f);
    CGFloat radius   = MIN(self.bounds.size.height, self.bounds.size.width)/2.0f;
    CGFloat progress = MIN(self.progress, 1.0f-FLT_EPSILON);
    CGFloat radians  = (float)(progress*2.0f*M_PI - M_PI_2);
    
    CGContextSetFillColorWithColor(context, self.trackTintColor.CGColor);
    [self drawArcInCenter:centerPoint withStartAngle:2.0f*M_PI  withEndAngle:radians withRadius:radius inContext:context];
    
    if (progress > 0.0f) {
        CGContextSetFillColorWithColor(context, self.progressTintColor.CGColor);
        [self drawArcInCenter:centerPoint withStartAngle:3.0f * M_PI_2  withEndAngle:radians withRadius:radius inContext:context];
    }
    
    CGContextSetBlendMode(context, kCGBlendModeClear);
    [self drawCircleInCenter:centerPoint withRadius:radius*0.9f inContext:context];
}

@end

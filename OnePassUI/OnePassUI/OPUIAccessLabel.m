//
//  OPUIAccessLabel.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 18.07.16.
//  Copyright © 2016 Soloshcheva Aleksandra. All rights reserved.
//

#import "OPUIAccessLabel.h"

@implementation OPUIAccessLabel

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    for (CGFloat radius = 50, alpha = 0.8; radius < 100; radius += 15 , alpha -= 0.15) {
        [self addCircle2CurrentContextWitRadius:radius withAlpha:alpha];
    }
    
    CGContextRestoreGState(context);
    
    
}


-(void)addCircle2CurrentContextWitRadius:(CGFloat)radius withAlpha:(CGFloat)alpha{
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGRect bounds = [self bounds];
    
    CGPoint center;
    center.x = bounds.origin.x + bounds.size.width / 2.0;
    center.y = bounds.origin.y + bounds.size.height / 2.0;
    
    CGContextSetLineWidth(currentContext,1);
    
    //CGContextSetShadow(currentContext, CGSizeMake (-1,  1), 1);
    
    const CGFloat* components = CGColorGetComponents(self.textColor.CGColor);
    CGContextSetRGBStrokeColor(currentContext, components[0], components[1], components[2], alpha);
    
    CGContextAddArc(currentContext, center.x, center.y, radius, 0, M_PI*2, YES);
    
    CGContextClosePath(currentContext);
    
    CGContextStrokePath(currentContext);
}

- (void)drawTextInRect:(CGRect)rect{
    [super drawTextInRect:CGRectMake(rect.size.width/2-rect.size.width/8, 0, rect.size.width/4, rect.size.height)];
}

@end

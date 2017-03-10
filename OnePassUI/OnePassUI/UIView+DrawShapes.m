//
//  UIView+DrawShapes.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 15.12.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "UIView+DrawShapes.h"

@implementation UIView (DrawShapes)

-(void)drawCircleInCenter:(CGPoint)center
               withRadius:(float)radius
                inContext:(CGContextRef )context{
    CGRect rect = (CGRect) {
        .origin.x = center.x - radius,
        .origin.y = center.y - radius,
        .size.width  = radius * 2.0f,
        .size.height = radius * 2.0f
    };
    CGContextAddEllipseInRect(context, rect);
    CGContextFillPath(context);
}

-(void)drawArcInCenter:(CGPoint)center
        withStartAngle:(float)startAngle
          withEndAngle:(float)endAngle
            withRadius:(float)radius
             inContext:(CGContextRef)context{
    CGMutablePathRef trackPath = CGPathCreateMutable();
    CGPathMoveToPoint(trackPath, NULL, center.x, center.y);
    CGPathAddArc(trackPath, NULL, center.x, center.y, radius, startAngle, endAngle, TRUE);
    CGPathCloseSubpath(trackPath);
    CGContextAddPath(context, trackPath);
    CGContextFillPath(context);
    CGPathRelease(trackPath);
}

-(void)drawCrossInCenter:(CGPoint)center
              withRadius:(float)radius
               inContext:(CGContextRef)context{
    [self drawCrossLineInCenter:CGPointMake(center.x, center.y + radius)
                     withRadius:radius
                       andAngle:-M_PI/4
                      inContext:context];
    [self drawCrossLineInCenter:CGPointMake(center.x + kLineWidth , center.y - radius)
                     withRadius:radius
                       andAngle:M_PI/4
                      inContext:context];
}

-(void)drawCrossLineInCenter:(CGPoint)center
                  withRadius:(CGFloat)radius
                    andAngle:(CGFloat)radians
                   inContext:(CGContextRef)context{
    CGAffineTransform move = CGAffineTransformMakeTranslation(center.x - radius/2, center.y + (radius/2)*radians/fabs(radians));
    CGAffineTransform rotation = CGAffineTransformRotate(move, radians);
    
    float lenght = sqrtf(2*radius*radius);
    
    CGMutablePathRef markPath = CGPathCreateMutable();
    CGPathAddRect(markPath, &rotation, CGRectMake(0, 0 , lenght, kLineWidth));
    
    CGPathCloseSubpath(markPath);
    CGContextAddPath(context, markPath);
    
    CGContextFillPath(context);
    CGPathRelease(markPath);
}

-(void)drawMarkerInCenter:(CGPoint)center
               withRadius:(float)radius
                inContext:(CGContextRef)context{
    
    [self drawRotatedRect:CGRectMake(0, 0, radius, radius/2)
                  inPoint:CGPointMake(center.x - radius/2 , center.y + kLineWidth)
                withAngel:-M_PI_4
                inContext:context];
    
    CGContextSetBlendMode(context, kCGBlendModeClear);
    [self drawRotatedRect:CGRectMake(kLineWidth, -kLineWidth, radius, radius/2)
                  inPoint:CGPointMake(center.x - radius/2 , center.y + kLineWidth)
                withAngel:-M_PI_4
                inContext:context];
}

-(void)drawRotatedRect:(CGRect)rect
               inPoint:(CGPoint)point
             withAngel:(CGFloat)angle
             inContext:(CGContextRef)context{
    CGAffineTransform move = CGAffineTransformMakeTranslation(point.x , point.y);
    CGAffineTransform rotation = CGAffineTransformRotate(move, angle);
    
    CGMutablePathRef markPath = CGPathCreateMutable();
    CGPathAddRect(markPath, &rotation, rect);
    
    CGPathCloseSubpath(markPath);
    CGContextAddPath(context, markPath);
    CGContextFillPath(context);
    CGPathRelease(markPath);
}

@end

//
//  UIView+DrawShapes.h
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 15.12.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <UIKit/UIKit.h>

static const float kLineWidth = 5.0;

@interface UIView (DrawShapes)

/**
 Draws the circle in the context

 @param center The center of the circle
 @param radius The radius of the circle
 @param context The context
 */
-(void)drawCircleInCenter:(CGPoint)center
               withRadius:(float)radius
                inContext:(CGContextRef)context;

/**
 Draw the arc in the context

 @param center The center of the arc
 @param startAngle The start angle of arc
 @param endAngle The end angle of arc
 @param radius The radius of the arc
 @param context The context 
 */
-(void)drawArcInCenter:(CGPoint)center
        withStartAngle:(float)startAngle
          withEndAngle:(float)endAngle
            withRadius:(float)radius
             inContext:(CGContextRef)context;

/**
 Draws the cross('×') inscribed into the circle

 @param center The center of the circle
 @param radius The radius of the circle
 @param context The context
 */
-(void)drawCrossInCenter:(CGPoint)center
              withRadius:(float)radius
               inContext:(CGContextRef)context;

/**
 Draws the marker('∟') inscribed into the circle

 @param center The center of the circle
 @param radius The radius of the circle
 @param context The context
 */
-(void)drawMarkerInCenter:(CGPoint)center
               withRadius:(float)radius
                inContext:(CGContextRef)context;

@end

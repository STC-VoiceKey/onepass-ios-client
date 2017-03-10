//
//  OPUIDivergentCirclesView.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 09.11.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPUIDivergentCirclesView.h"

#import "UIView+DrawShapes.h"

static const float kAnimationDuration = 0.4f;

@interface OPUIDivergentCirclesView()

@property (nonatomic) BOOL isChangeOrientationObserver;

@end

@interface OPUIDivergentCirclesView (PrivateMethods)

/**
 Creates the circle path witn the radius in the center

 @param center The center of the circle
 @param radius The radius of the circle
 @return The circle path
 */
-(CGMutablePathRef)newCirclePathInCenter:(CGPoint)center
                              withRadius:(float)radius;

/**
 Creates the shape layer with opacity and the line width

 @param opacity The opacity
 @param width The line width
 @return The new shape layer
 */
-(CAShapeLayer *)createShapeLayerWithOpacity:(float)opacity
                                   withWidth:(float)width;

/**
 Creates the animation form the small circle to the large one
 
 @param from The small circle path
 @param to The large circle path
 @return The new animation
 */
-(CABasicAnimation *)createAnimationFrom:(id)from to:(id)to;

@end

@implementation OPUIDivergentCirclesView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    [self.layer addSublayer:[self createCircleWithRadius:self.radius withWidth:1 withOpacity:0.2 withOrder:5]];
    [self.layer addSublayer:[self createCircleWithRadius:self.radius withWidth:2 withOpacity:0.4 withOrder:4]];
    [self.layer addSublayer:[self createCircleWithRadius:self.radius withWidth:3 withOpacity:0.6 withOrder:3]];
    [self.layer addSublayer:[self createCircleWithRadius:self.radius withWidth:4 withOpacity:0.8 withOrder:2]];
    [self.layer addSublayer:[self createCircleWithRadius:self.radius withWidth:5 withOpacity:1.0 withOrder:1]];
    
    if (self.failStatus){
        [self showCross];
    }
    else {
        [self showMarker];
    }
}

-(void)showCircleWithRadius:(float)radius
                  withWidth:(float)width
                withOpacity:(float)opacity{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGPoint centerPoint = CGPointMake(self.center.x, self.center.y-self.radius);

    CGContextSetBlendMode(context, kCGBlendModeColor);
    CGContextSetFillColorWithColor(context, [self.tintColor colorWithAlphaComponent:opacity].CGColor);
    [self drawCircleInCenter:centerPoint withRadius:radius inContext:context];
    
    CGContextSetBlendMode(context, kCGBlendModeClear);
    [self drawCircleInCenter:centerPoint withRadius:radius - width inContext:context];
}

-(CALayer *)createCircleWithRadius:(float)radius
                         withWidth:(float)width
                       withOpacity:(float)opacity
                         withOrder:(NSUInteger)order{
    CGPoint centerPoint = CGPointMake(self.center.x, self.center.y - self.radius);
    
    CGMutablePathRef path = [self newCirclePathInCenter:centerPoint withRadius:radius];
    
    CAShapeLayer *layer = [self createShapeLayerWithOpacity:opacity withWidth:width];
    layer.path = path;
    
    CGFloat newRadius = radius + order * 15;
    CGMutablePathRef newPath =  [self newCirclePathInCenter:centerPoint withRadius:newRadius];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((order * 0.05) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CABasicAnimation *animation = [self createAnimationFrom:(__bridge id)path to:(__bridge id)newPath];
        [layer addAnimation:animation forKey:@"path"];
        layer.path = newPath;
        
        CGPathRelease(newPath);
        CGPathRelease(path);
    });

    return layer;
}

-(void)showMarker{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGPoint centerPoint = CGPointMake(self.center.x, self.center.y-self.radius);
    
    CGContextSetBlendMode(context, kCGBlendModeColor);
    CGContextSetFillColorWithColor(context, self.tintColor.CGColor);
    [self drawMarkerInCenter:centerPoint withRadius:self.radius inContext:context];
}

-(void)showCross{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGPoint centerPoint = CGPointMake(self.center.x, self.center.y - self.radius);

    CGContextSetFillColorWithColor(context, self.tintColor.CGColor);
    [self drawCrossInCenter:centerPoint withRadius:self.radius inContext:context];
}

@end

@implementation  OPUIDivergentCirclesView (PrivateMethods)

-(CGMutablePathRef)newCirclePathInCenter:(CGPoint)center
                              withRadius:(float)radius{
    CGRect rect = (CGRect) {
        .origin.x = center.x - radius,
        .origin.y = center.y - radius,
        .size.width  = radius*2.0f,
        .size.height = radius*2.0f
    };
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddEllipseInRect(path, nil, rect);
    return path;
}

-(CAShapeLayer *)createShapeLayerWithOpacity:(float)opacity withWidth:(float)width{
    CAShapeLayer *layer = [[CAShapeLayer alloc] initWithLayer:self.layer];
    layer.fillColor   = UIColor.clearColor.CGColor;
    layer.strokeColor = [self.tintColor colorWithAlphaComponent:opacity].CGColor;
    layer.opacity = opacity;
    layer.lineWidth = width;
    return layer;
}

-(CABasicAnimation *)createAnimationFrom:(id)from to:(id)to{
    CASpringAnimation *animation = [CASpringAnimation animationWithKeyPath:@"path"];
    animation.duration = kAnimationDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animation.fromValue = from;
    animation.toValue   = to;
    return animation;
}

@end

//
//  OPUIBubbleProgressView.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 11.11.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPUIBubbleProgressView.h"

static const int pointsPerView = 20;
static const int pointPerHalf  = pointsPerView /2;

@interface OPUIBubbleProgressView()

@property (nonatomic) NSMutableArray<CALayer *>* currentlayers;

@end

@implementation OPUIBubbleProgressView

- (void)drawRect:(CGRect)rect {

    float y0 = self.bounds.size.height / 2;
    float x0 = -self.bounds.size.width;
    
    float deltaY = self.bounds.size.height/pointsPerView;
    
    float curveradius = self.bounds.size.width*2;
    
    if(!self.currentlayers)
        self.currentlayers = [[NSMutableArray alloc] initWithCapacity:pointsPerView*2];

    for (int i = 0 ; i < pointsPerView/2; i++)
    {
        float y = i*deltaY;
        float a = asin(y/curveradius);
        float x = curveradius * cos(a);
        CALayer *newrightlayer = [self createCircle:CGPointMake(x + x0, y0 - y) withColor:[self colorWithindex:pointPerHalf-i]];
        [self changeSublayer:newrightlayer atIndex:i];
    }
    
    for (int i = 0 ; i < pointsPerView/2; i++)
    {
        float y = i*deltaY;
        float a = asin(y/curveradius);
        float x = curveradius * cos(a);
        CALayer *newrightlayer = [self createCircle:CGPointMake(x + x0, y + y0) withColor:[self colorWithindex:i+pointPerHalf]];
        [self changeSublayer:newrightlayer atIndex:i+pointPerHalf*1];
    }
    
    for (int i = 0 ; i < pointsPerView/2; i++)
    {
        float y = i*deltaY;
        float a = asin(y/curveradius);
        float x = curveradius * cos(a);
        CALayer *newrightlayer = [self createCircle:CGPointMake( 2*fabsf(x0) - x , y0 - y)
                                          withColor:[self colorWithindex:pointPerHalf-i]];
        [self changeSublayer:newrightlayer atIndex:i+pointPerHalf*2];
    }

    for (int i = 0 ; i < pointsPerView/2; i++)
    {
        float y = i*deltaY;
        float a = asin(y/curveradius);
        float x = curveradius * cos(a);
        CALayer *newrightlayer = [self createCircle:CGPointMake( 2*fabsf(x0) - x , y + y0)
                                          withColor:[self colorWithindex:i+pointPerHalf]];
        [self changeSublayer:newrightlayer atIndex:i+3*pointPerHalf];
    }


    

}

-(void)changeSublayer:(CALayer *)layer atIndex:(int)index
{
    if(index < self.currentlayers.count)
    {
        [self.layer replaceSublayer:[self.currentlayers objectAtIndex:index]
                               with:layer];
        [self.currentlayers replaceObjectAtIndex:index
                                      withObject:layer];
    }
    else
    {
        [self.layer addSublayer:layer];
        [self.currentlayers insertObject:layer
                                 atIndex:index];
    }
}

-(UIColor *)colorWithindex:(int)index{
    if (self.progress==0) return self.fillColor;
    
    return ( ( 1 - [@(index) floatValue]/20) > self.progress) ? self.fillColor : self.successColor;
}

-(CALayer *)createCircle:(CGPoint)point withColor:(UIColor *)color
{
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    float radius = self.bubbleRadius;
    
    CGRect rect = (CGRect) {
        .origin.x = point.x - radius, .origin.y = point.y - radius,
        .size.width = radius * 2.0f, .size.height = radius * 2.0f
    };
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddEllipseInRect(path, nil, rect);
    
    layer.path = path;
    layer.fillColor   =  color.CGColor;
    layer.strokeColor = self.strokeColor.CGColor;
    layer.lineWidth = 1;
    
    CGPathRelease(path);
    
    return layer;
}

@end

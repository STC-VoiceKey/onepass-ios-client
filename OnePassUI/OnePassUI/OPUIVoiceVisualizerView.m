//
//  OPUIVoiceVisualizerView.m
//  OnePassUICommon
//
//  Created by Soloshcheva Aleksandra on 28.10.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPUIVoiceVisualizerView.h"

///The setting of the voice wave
static const float kLineWidth  = 1;
static const int   kSamplesPerLine = 440;
static const float kAnimationDuration = 0.2;
static const float kZeroLimit = 0.01;
static const float kMaxSampleValue = 32768;

@interface OPUIVoiceVisualizerView()

/**
 The current 'X' coordinate
 */
@property (nonatomic) float currentPoint;

/**
 Shows that the voice wave is displayed
 */
@property (nonatomic) BOOL isStarted;

@property (nonatomic) IBOutlet NSLayoutConstraint *centerConstarint;

@end

@interface OPUIVoiceVisualizerView(PrivateMethods)

/**
 Creates the visual layer with the one value of the voice wave

 @return The new layer
 */
-(CAShapeLayer *)createShapeLayer;


/**
 Creates the animation from the point wave to the real voice wave

 @param from The point wave path
 @param to The real voice wave path
 @return The new animation
 */
-(CABasicAnimation *)createAnimationFrom:(id)from to:(id)to;

@end

@implementation OPUIVoiceVisualizerView

-(void)setHidden:(BOOL)hidden{
    [super setHidden:hidden];                                                               
    
    self.layer.opacity = hidden ? 0 : 1;
    self.layer.sublayers = nil;
    
    self.isStarted = NO;
}

-(void)visualizeVoiceBuffer:(const void *)bytes
                     length:(NSUInteger)length{
    if (!self.isStarted) {
        self.frame = CGRectMake(0, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
        
        self.isStarted = YES;
        self.currentPoint = 0;
        
        __weak typeof(self) weakself = self;
        
        float offset = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? -weakself.frame.size.width/4 : (-weakself.frame.size.width/2);

        dispatch_async(dispatch_get_main_queue(), ^{
            self.centerConstarint.constant = offset;
             [UIView animateWithDuration:9.3
                                   delay:0.7
                                 options:UIViewAnimationOptionCurveLinear
                              animations:^{
                [self.superview setNeedsLayout];
                [self.superview layoutIfNeeded];
                              }  completion:^(BOOL finished) {
                                  self.centerConstarint.constant = 0;
                              }];
        });

     }
    
    short *pointer = (short *)bytes;
    
    //попробовать сглаживающий фильтр v[i] = ¼·s[i-1] + ½·s[i] + ¼·s[i+1]
    float max = 0;
    for (int i = 0; i < (length /2); i++, pointer++) {
        double value = (double)*pointer;
        if(value > max) max = value;
        
        if(i % kSamplesPerLine == 0) {
            __weak typeof(self) weakself = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakself displayLine:max];
                
            });
            max = 0;
        }
    }
}

-(void)displayLine:(float)count{
    float value = fabsf( count/kMaxSampleValue );
    value = (value < kZeroLimit) ? kZeroLimit : value;
    
    CGRect lineRect = CGRectMake(self.currentPoint, self.bounds.size.height/2 - value*self.bounds.size.height/2,
                                 kLineWidth, value*self.bounds.size.height);
    UIBezierPath *linePath = [UIBezierPath bezierPathWithRoundedRect:lineRect cornerRadius:kLineWidth];
    
    CGRect dotRect = CGRectMake(self.currentPoint, self.bounds.size.height/2 - kLineWidth, kLineWidth, kLineWidth);
    UIBezierPath *dotPath = [UIBezierPath bezierPathWithRoundedRect:dotRect cornerRadius:kLineWidth];

    CAShapeLayer *layer = [self createShapeLayer];
    
    CABasicAnimation *animation = [self createAnimationFrom:(__bridge id)dotPath.CGPath to:(__bridge id)linePath.CGPath];
   
    [layer addAnimation:animation forKey:@"path"];
    layer.path = linePath.CGPath;
    
    [self.layer addSublayer:layer];
    
   // layer.shouldRasterize = YES;

    self.currentPoint += 2;
    
}

@end

@implementation OPUIVoiceVisualizerView(PrivateMethods)

-(CAShapeLayer *)createShapeLayer{
    CAShapeLayer *layer = [[CAShapeLayer alloc] initWithLayer:self.layer];
    layer.fillColor   = self.waveColor.CGColor;
    layer.strokeColor = self.waveColor.CGColor;
    layer.opacity = 1.0;
    layer.lineWidth = kLineWidth/2;
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



//
//  OPUIDisableParentActivityIndicatorView.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 23.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "OPUIActivityIndicatorView.h"
#import "OPUI3QuarterArcView.h"
#import "OPUICorporateColorUtils.h"

@interface OPUIActivityIndicatorView()

@property (nonatomic) OPUI3QuarterArcView *arcView;

/**
 The timer used to delay the finishing marker displaying
 */
@property (nonatomic,strong) NSTimer *delayedTimer;

@end

@interface OPUIActivityIndicatorView (PrivateMethods)

/**
 Creates the arc view

 @return The new arc view
 */
-(OPUI3QuarterArcView *)createArcView;

/**
 Is invoked when the device orientation is changed
 */
-(void)updateOrientation;

@end

@implementation OPUIActivityIndicatorView

-(UIView *)createBackgroundView {
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.superview.bounds];
    
    backgroundView.backgroundColor = OPUITurquoiseWithAlpha(1);

    self.arcView.showFail = NO;
    self.hidesWhenStopped = YES;
    
    return backgroundView;
}

-(void)startAnimating {
    [super startAnimating];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(updateOrientation)
                                               name:UIDeviceOrientationDidChangeNotification
                                             object:nil];
    
    if (self.backgroundView == nil) {
        self.arcView = [self createArcView];
        self.backgroundView = [self createBackgroundView];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.backgroundView addSubview:self.arcView];
            [self.superview addSubview:self.backgroundView];
        });
    } else {
        self.backgroundView.alpha = 1;
    }
    
    self.backgroundView.frame = self.superview.bounds;
    self.arcView.frame = self.superview.bounds;
    [self.superview bringSubviewToFront:self.backgroundView];
}

-(void)dealloc{
    [_delayedTimer invalidate];
    _delayedTimer = nil;
}

-(void)stopAnimating {
    if(!self.isAnimating) {
       return;
    }
    
    __weak typeof(self.backgroundView) weakBackgroundView = self.backgroundView;

    [UIView animateWithDuration:2.2
                     animations:^{
                         if (weakBackgroundView) {
                             weakBackgroundView.alpha = 0.0;
                         }
                     }
                     completion:^(BOOL finished){
                         if (weakBackgroundView) {
                            // weakBackgroundView.alpha = 1.0;
                             [weakBackgroundView.superview sendSubviewToBack:weakBackgroundView];
                         }
                     }];
    
    [super stopAnimating];
}

-(void)setTag:(NSInteger)tag {
    switch (tag) {
        case 1:
            self.arcView.showFail = YES;
            self.arcView.fail = YES;
            break;
        case 2:
            self.arcView.showFail = YES;
            self.arcView.fail = NO;
            break;
        default:
            self.arcView.showFail = NO;
            break;
    }
}

@end

@implementation  OPUIActivityIndicatorView (PrivateMethods)

-(OPUI3QuarterArcView *)createArcView {
    OPUI3QuarterArcView *arcView = [[OPUI3QuarterArcView alloc] initWithFrame:self.superview.frame];
    arcView.center = self.center;
    arcView.tintColor = self.color;
    arcView.radius  = self.radius;
    arcView.backgroundColor = UIColor.clearColor;
    
    return arcView;
}

-(void)updateOrientation {
    self.backgroundView.frame = self.backgroundView.superview.bounds;
    for (UIView *view in self.backgroundView.subviews) {
        view.frame = self.backgroundView.superview.bounds;
    }
}

@end

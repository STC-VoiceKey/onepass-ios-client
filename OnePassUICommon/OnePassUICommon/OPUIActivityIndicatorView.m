//
//  OPUIDisableParentActivityIndicatorView.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 23.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPUIActivityIndicatorView.h"
#import "OPUICorporateColorUtils.h"

@interface OPUIActivityIndicatorView()

@property (nonnull) UIView *disableView;

@end

@implementation OPUIActivityIndicatorView

-(void)startAnimating{

    [super startAnimating];
    self.superview.userInteractionEnabled = NO;
    
    if (self.disableView==nil) {
        self.disableView = [[UIView alloc] initWithFrame:self.superview.frame];
        self.disableView.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:0.7];
    }
    
    [self.superview addSubview:self.disableView];
    [self.superview bringSubviewToFront:self];

}

-(void)stopAnimating{
    [super stopAnimating];
    self.superview.userInteractionEnabled = YES;
    [self.disableView removeFromSuperview];
//    self.superview.alpha = 1;
}

@end

//
//  OPUIActivityIndicatorBlackView.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 08.11.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPUIActivityIndicatorBlackView.h"

@implementation OPUIActivityIndicatorBlackView

-(UIView *)createBackgroundView{
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.superview.bounds];
    
    UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualEffectView.frame  = backgroundView.bounds;

    [backgroundView addSubview:visualEffectView];
    
    return backgroundView;
}

@end

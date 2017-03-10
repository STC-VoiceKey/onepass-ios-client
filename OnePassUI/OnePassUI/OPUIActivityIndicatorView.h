//
//  OPUIDisableParentActivityIndicatorView.h
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 23.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 The activity indicator with the rotating arc and the overlapping background
 */
@interface OPUIActivityIndicatorView : UIActivityIndicatorView

/**
 The radius of the arc
 */
@property (nonatomic,assign) IBInspectable CGFloat radius;

/**
 The background view
 */
@property (nonatomic) UIView *backgroundView;

/**
 Creates and adds the background view
 @return The new background view
 */
-(UIView *)createBackgroundView;

@end

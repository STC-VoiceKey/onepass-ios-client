//
//  OPUILayoutConstraint.h
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 27.10.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Customizes the layout constraint for different devices
 */
@interface OPUILayoutConstraint : NSLayoutConstraint

/**
 Constrant value for iPhone 1-5S, iPhoneSE, iPod
 */
@property (nonatomic,assign) IBInspectable CGFloat smallDevicesValue;

/**
 Constrant value for  iPhone 6, 6S, 7
 */
@property (nonatomic,assign) IBInspectable CGFloat middleDevicesValue;

/**
 Constrant value for iPad, iPhone 6 Plus, 6s Plus, 7 Plus
 */
@property (nonatomic,assign) IBInspectable CGFloat largeDevicesValue;

@end

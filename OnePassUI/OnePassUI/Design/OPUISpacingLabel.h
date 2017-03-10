//
//  OPUISpacingLabel.h
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 27.10.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 The label which has the variable value of spacing between letters
 */
@interface OPUISpacingLabel : UILabel

/**
 Constraint value for iPhone 1-5S, iPhoneSE, iPod
 */
@property (nonatomic,assign) IBInspectable CGFloat smallDevicesValue;

/**
 Constraint value for  iPhone 6, 6S, 7
 */
@property (nonatomic,assign) IBInspectable CGFloat middleDevicesValue;

/**
 Constraint value for iPad, iPhone 6 Plus, 6s Plus, 7 Plus
 */
@property (nonatomic,assign) IBInspectable CGFloat largeDevicesValue;

@end

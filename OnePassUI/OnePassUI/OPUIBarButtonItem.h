//
//  OPUIToolBarButtonItem.h
//  OnePassCapture
//
//  Created by Soloshcheva Aleksandra on 02.11.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 The custom bar buttom item contains the warning message and the xib file name that displays the hint to user
 */
@interface OPUIBarButtonItem : UIBarButtonItem

/**
 The warning message
 */
@property (nonatomic, strong) IBInspectable NSString *warning;

/**
 The XIB file contains the hint view
 @warning The root view of XIB file must be OPUIWarningView
 */
@property (nonatomic, strong) IBInspectable NSString *xibName;

@end

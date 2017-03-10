//
//  OPUIResultView.h
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 08.11.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Displays the verification result with the animation of the radiating concentric circles
 */
@interface OPUIResultView : UIView

/**
 The radius of inner circle
 */
@property (nonatomic) IBInspectable float radius;

/**
 The verification result. Based on it the view draws the cross or the marker in the inner circle
 */
@property (nonatomic) IBInspectable BOOL  fail;

@end

//
//  OPUI3QuarterArcView.h
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 01.11.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Draws the arc and rotates it                 
 */
@interface OPUI3QuarterArcView : UIView

/**
 The radius of the arc
 */
@property (nonatomic,assign) IBInspectable CGFloat radius;

/**
 Shows that the finishing process is started and it is necessary to display the finishing marker
 */
@property (nonatomic) BOOL finisning;

/**
 Shows that the process is finished with the failure result
 */
@property (nonatomic) BOOL fail;

/**
 Shows that it is necessary to display the result marker
 */
@property (nonatomic) BOOL showFail;

@end

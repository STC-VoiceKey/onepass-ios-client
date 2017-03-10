//
//  UIActivityIndicatorView+Status.h
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 03.11.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 The category sets the status of the activity indicator
 */
@interface UIActivityIndicatorView (Status)

/**
 Resets the activity indicator status
 */
-(void)resetActivityIndicatorStatus;

/**
 Sets the status of the activity indicator to failure
 */
-(void)setActivityIndicatorStatus2Fail;

/**
 Sets the status of the activity indicator to success
 */
-(void)setActivityIndicatorStatus2Success;

@end

//
//  OPUIDivergentCirclesView.h
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 09.11.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
  Displays the five divergent circles with the animation and draws the cross or the marker in the center on the basis of the status
 */
@interface OPUIDivergentCirclesView : UIView

/**
 The radius of the first circle
 */
@property (nonatomic) float radius;

/**
 The verification status
 */
@property (nonatomic) BOOL  failStatus;

@end

//
//  OPUIRotatableViewController.h
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 08.02.17.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import <OnePassUI/OnePassUI.h>
#import "OPUITimedBaseViewController.h"

/**
 The view controller used for all view controllers which should to support interface orientation changing 
 */
@interface OPUIRotatableViewController : OPUITimedBaseViewController

/**
 Updates interface orientation
 */
-(void)updateOrientation;

/**
 @return Return current interface orientation
 */
-(OPCAvailableOrientation)currentOrientation;

@end

//
//  OPUITimedBaseViewController.h
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 14.02.17.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import <OnePassUI/OnePassUI.h>


/**
 The view controller used for all view controllers which should be off after 3 minutes
 */
@interface OPUITimedBaseViewController : OPUIBaseViewController

/**
 Is invoked after the timer is expared
 */
-(void)viewTimerDidExpared;

@end

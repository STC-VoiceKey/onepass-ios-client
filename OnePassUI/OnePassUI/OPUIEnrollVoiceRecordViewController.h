//
//  OPUIBaseVoiceRecordViewController.h
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 22.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OPUITimedBaseViewController.h"

/**
 Captures the voice sample
 */
@interface OPUIEnrollVoiceRecordViewController : OPUITimedBaseViewController

/**
 The order number of the voice sample
 */
@property (nonatomic,assign) NSUInteger numberOfSample;

@end

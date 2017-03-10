//
//  OPUIIndicatorsViewController.h
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 08.12.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OPUIBaseViewController.h"

/**
 The block which is invoked when the indicators states are changed

 @param isReady YES, if all indicators show valid statuses
 */
typedef void (^ReadyBlock) (BOOL isReady);

/**
 The view controller shows the state of portrait features and environment
 */
@interface OPUIIndicatorsViewController : OPUIBaseViewController

/**
 The color of the indicator when the indicator status is success
 */
@property (nonatomic, readonly)    UIColor *goodColor;

/**
 The color of indicator when the indicator status is not success
 */
@property (nonatomic, readonly)    UIColor *failColor;


/**
 The indicator toolbar
 */
@property (nonatomic, weak) IBOutlet UIToolbar *indicatorToolbar;

/**
 The view where the face mask is shown
 */
@property (nonatomic, weak)  UIView *viewMaskContainer;


/**
 The instance of 'IOPCPortraitFeaturesProtocol' and 'IOPCEnvironmentProtocol'
 */
@property (nonatomic) id<IOPCPortraitFeaturesProtocol,
                              IOPCEnvironmentProtocol> frameCaptureManager;


/**
 The block
 */
@property (nonatomic) ReadyBlock readyBlock;

/**
 Stops observing the state of indicators
 */
-(void)stopObserving;

@end

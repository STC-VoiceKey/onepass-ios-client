//
//  OPUIBaseVoiceRecordViewController.h
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 22.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OPUIVoiceViewProtocol.h"
#import "OPUITimedBaseViewController.h"
#import "OPUIVoicePresenterProtocol.h"

/**
 Captures the voice sample
 */
@interface OPUIVoiceViewController : OPUITimedBaseViewController<OPUIVoiceViewProtocol>

@property (nonatomic) id<OPUIVoicePresenterProtocol> presenter;

@end

//
//  OPUIEnrollVoiceViewController.h
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 20.11.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import "OPUIVoiceViewController.h"

#import "OPUIEnrollVoiceViewProtocol.h"

@interface OPUIEnrollVoiceViewController : OPUIVoiceViewController<OPUIEnrollVoiceViewProtocol>

/**
 The order number of the voice sample
 */
@property (nonatomic,assign) NSUInteger numberOfSample;

@end

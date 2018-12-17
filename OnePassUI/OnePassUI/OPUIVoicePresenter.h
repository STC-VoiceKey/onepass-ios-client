//
//  OPUIEnrollVoicePresenter.h
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 10.11.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OPUIVoiceViewProtocol.h"
#import "OPUIVoiceServiceProtocol.h"
#import "OPUIVoicePresenterProtocol.h"

@interface OPUIVoicePresenter : NSObject<OPUIVoicePresenterProtocol>

@property (nonatomic) id<IOPCCaptureVoiceManagerProtocol>  voiceManager;

@property (nonatomic) id<OPUIVoiceViewProtocol> view;

@property (nonatomic) id<OPUIVoiceServiceProtocol> service;

@end

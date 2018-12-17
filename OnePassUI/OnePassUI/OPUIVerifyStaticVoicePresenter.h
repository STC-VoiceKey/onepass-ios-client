//
//  OPUIVerifyStaticVoicePresenter.h
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 21.08.2018.
//  Copyright © 2018 Speech Technology Center. All rights reserved.
//

#import "OPUIVoicePresenter.h"

#import "OPUIVerifyStaticVoicePresenterProtocol.h"

@interface OPUIVerifyStaticVoicePresenter : OPUIVoicePresenter<OPUIVerifyStaticVoicePresenterProtocol>

-(void)setupService;

@end


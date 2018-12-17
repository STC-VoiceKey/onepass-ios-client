//
//  OPUIEnrollStaticVoicePresenterProtocol.h
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 01.08.2018.
//  Copyright © 2018 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OPUIEnrollVoiceViewProtocol.h"
#import "OPUIVoicePresenterProtocol.h"

@protocol OPUIEnrollStaticVoicePresenterProtocol <OPUIVoicePresenterProtocol>

-(void)attachView:(id<OPUIEnrollVoiceViewProtocol>)view
   numberOfSample:(NSUInteger)sampleNumber;

@end

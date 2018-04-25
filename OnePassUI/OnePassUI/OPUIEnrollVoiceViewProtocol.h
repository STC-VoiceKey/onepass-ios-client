//
//  OPUIEnrollVoiceViewProtocol.h
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 22.11.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <OnePassCore/OnePassCore.h>
#import <OnePassCapture/OnePassCapture.h>

#import "OPUIVoiceViewProtocol.h"

@protocol OPUIEnrollVoiceViewProtocol <OPUIVoiceViewProtocol>

-(void)setNumberOfSample:(NSUInteger)sampleNumber;
-(void)routeToNextVoice;

@end

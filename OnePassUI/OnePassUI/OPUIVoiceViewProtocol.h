//
//  OPUIVoiceViewProtocol.h
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 17.11.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OnePassCore/OnePassCore.h>
#import <OnePassCapture/OnePassCapture.h>

#import "OPUIProgressViewProtocol.h"
#import "OPUIActivityViewProtocol.h"
#import "OPUIWaveViewProtocol.h"

@protocol OPUIVoiceViewProtocol <OPUIProgressViewProtocol,
                                 OPUIActivityViewProtocol,
                                     OPUIWaveViewProtocol>

-(void)hideNoiseIndicator;
-(void)showNoiseIndicator;

-(void)showStartState;
-(void)showStopState;

-(void)disabledStartButton;
-(void)enabledStartButton;

-(void)showDigit:(NSString *)digit;


-(void)showError:(NSError *)error;
-(void)routeToPageWithError:(NSError *)error;
-(void)exit;

-(id<IOPCVoiceVisualizerProtocol>)visualView;
-(id<IOPCTransportProtocol>)service;


@end

//
//  OPUIFaceAndVoiceViewProtocol.h
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 22.11.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OPUIVerifyFaceViewProtocol.h"
#import "OPUIProgressViewProtocol.h"


@protocol OPUIVerifyFaceAndVoiceViewProtocol <OPUIVerifyFaceViewProtocol,
                                                OPUIProgressViewProtocol>

-(void)hideNoiseIndicator;
-(void)showNoiseIndicator;

-(void)configureDigits:(NSString *)digits;
-(void)showDigits;
-(void)hideDigits;

-(void)showIndicators;
-(void)hideIndicators;

-(id<IOPCCaptureVoiceManagerProtocol>)voiceManager;

-(void)showAlertError:(NSError *)error;

@end

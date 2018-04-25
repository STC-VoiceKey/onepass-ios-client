//
//  OPUIVoicePresenterProtocol.h
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 20.11.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <OnePassCapture/OnePassCapture.h>
#import <OnePassCore/OnePassCore.h>

#import "OPUIVoiceViewProtocol.h"

@protocol OPUIVoicePresenterProtocol <NSObject>

-(id)initWith:(id<IOPCCaptureVoiceManagerProtocol>)voiceManager withService:(id<IOPCTransportProtocol>)service;

-(void)attachView:(id<OPUIVoiceViewProtocol>)view;
-(void)deattachView;

-(void)didCancelAction;
-(void)onAction;

-(void)processVoice:(NSData *)data;

@end

//
//  OPUIStaticVoiceServiceProtocol.h
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 01.08.2018.
//  Copyright © 2018 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OPUIVoiceServiceProtocol.h"

@protocol OPUIStaticVoiceServiceProtocol <OPUIVoiceServiceProtocol>

-(void)setService:(id<IOPCTransportProtocol>)service;

-(void)processVoice:(NSData *)data
        withHandler:(OPUIResultBlock)handler;

@end

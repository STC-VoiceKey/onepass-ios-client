//
//  OPUIVoiceServiceProtocol.h
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 20.11.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^OPUIResultBlock) (NSDictionary *result, NSError *error);

@protocol OPUIVoiceServiceProtocol

-(void)setService:(id<IOPCTransportProtocol>)service;

-(void)processVoice:(NSData *)data
     withPassphrase:(NSString *)passphrase
        withHandler:(OPUIResultBlock)handler;

@end


//
//  OPUIVerifyVoiceService.h
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 21.11.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <OnePassCore/OnePassCore.h>

typedef void (^OPUIVerifyVoiceResultBlock) (NSDictionary *result, NSError *error);

@protocol OPUIVerifyVoiceServiceProtocol

-(void)setService:(id<IOPCTransportProtocol>) service;

-(void)startVerificationForUser:(NSString *)user
                    withHandler:(OPUIVerifyVoiceResultBlock)handler;

-(void)verifyVoice:(NSData *)voice
       withHandler:(OPUIVerifyVoiceResultBlock)handler;

@end

@interface OPUIVerifyVoiceService : NSObject<OPUIVerifyVoiceServiceProtocol>

@end

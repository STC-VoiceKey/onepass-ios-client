//
//  OPUIVerifyStaticVoiceService.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 21.08.2018.
//  Copyright © 2018 Speech Technology Center. All rights reserved.
//

#import "OPUIVerifyStaticVoiceService.h"

@interface OPUIVerifyStaticVoiceService()

@property (nonatomic) id<IOPCTransportProtocol> service;

@end

@implementation OPUIVerifyStaticVoiceService

-(void)startVerificationForUser:(NSString *)user
                    withHandler:(OPUIVerifyVoiceResultBlock)handler {
    [self.service startVerificationSession:user
                       withCompletionBlock:^(id<IOPCVerificationSessionProtocol> session, NSError *error) {
                           if (!error) {
                               handler(nil,nil);
                           } else {
                               handler(nil,error);
                           }
                       }];
}


- (void)verifyVoice:(NSData *)voice
        withHandler:(OPUIVerifyVoiceResultBlock)handler {
    
    __weak typeof(self) weakself = self;
    [self.service addVerificationStaticVoice:voice
                         withCompletionBlock:^(NSDictionary *responceObject, NSError *error) {
                             if (error) {
                                 handler(nil,error);
                                 return;
                             }

                             [weakself.service verifyScoreWithCompletionBlock:nil];
                             [weakself.service verifyResultWithCompletionBlock:^(NSDictionary *responceObject, NSError *error) {
                                if (error) {
                                    handler(nil,error);
                                    return;
                                }
                           
                                 [weakself.service closeVerificationWithCompletionBlock:nil];
                                 handler( responceObject, nil);
                       }];
                       
                   }];
}


@end

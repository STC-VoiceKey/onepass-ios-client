//
//  OPUIVerifyVoiceService.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 21.11.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import "OPUIVerifyVoiceService.h"

@interface OPUIVerifyVoiceService()

@property (nonatomic) id<IOPCTransportProtocol> service;

@property (nonatomic) NSString *passphrase;

@end

@implementation OPUIVerifyVoiceService

-(void)startVerificationForUser:(NSString *)user
                    withHandler:(OPUIVerifyVoiceResultBlock)handler {
    [self.service startVerificationSession:user
                       withCompletionBlock:^(id<IOPCVerificationSessionProtocol> session, NSError *error) {
                           if (!error) {
                               self.passphrase = session.passphrase;
                               handler(@{ @"passphrase":session.passphrase },nil);
                           } else {
                              handler(nil,error);
                           }
                       }];
}

- (void)setService:(id<IOPCTransportProtocol>)service {
    _service = service;
}

- (void)verifyVoice:(NSData *)voice
        withHandler:(OPUIVerifyVoiceResultBlock)handler {
    
    __weak typeof(self) weakself = self;
    [self.service addVerificationVoice:voice
                        withPassphrase:self.passphrase
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

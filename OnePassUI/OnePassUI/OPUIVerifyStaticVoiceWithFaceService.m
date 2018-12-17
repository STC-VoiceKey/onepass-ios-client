//
//  OPUIVerifyStaticVoiceWithFaceService.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 27.08.2018.
//  Copyright © 2018 Speech Technology Center. All rights reserved.
//

#import "OPUIVerifyStaticVoiceWithFaceService.h"

@interface OPUIVerifyStaticVoiceWithFaceService()

@property (nonatomic) id<IOPCTransportProtocol> service;

@end

@implementation OPUIVerifyStaticVoiceWithFaceService

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

- (void)startVerificationForUser:(NSString *)user withHandler:(OPUIVerifyVoiceResultBlock)handler {

}


@end

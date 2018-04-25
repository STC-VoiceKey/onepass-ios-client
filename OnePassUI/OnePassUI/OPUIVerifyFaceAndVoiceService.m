//
//  OPUIVerifyFaceAndVoiceService.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 23.11.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import "OPUIVerifyFaceAndVoiceService.h"

#import <OnePassCore/OnePassCore.h>
#import "CIImage+Extra.h"

@interface OPUIVerifyFaceAndVoiceService()

@property (nonatomic) NSString *passphrase;
@property (nonatomic) NSString *user;

@end

@implementation OPUIVerifyFaceAndVoiceService

-(void)startSessionForUser:(NSString *)user
               withHandler:(OPUIVerifyResultBlock)handler {
    self.user = user;
    __weak typeof(self) weakself = self;
    [self.service startVerificationSession:user
                       withCompletionBlock:^(id<IOPCVerificationSessionProtocol> session, NSError *error) {
                           if (error) {
                               handler(nil,error);
                               return;
                           }
                           weakself.passphrase = session.passphrase;
                           
                           handler(@{ @"passphrase":session.passphrase },error);
                       }];
}


- (void)verifyPhoto:(CIImage *)image
           andVoice:(NSData *)voice
        withHandler:(OPUIVerifyResultBlock)handler {
    __weak typeof(self) weakself = self;

    [self.service addVerificationFace:image.nsData withCompletionBlock:^(NSDictionary *responceObject, NSError *error) {
        if (error) {
            handler(nil,error);
            return;
        }
        [weakself.service addVerificationVoice:voice
                                withPassphrase:weakself.passphrase
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
        }];

}

@end

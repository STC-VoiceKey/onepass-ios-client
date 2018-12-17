//
//  OPUIVerifyAddFaceForStaticVoiceService.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 24.08.2018.
//  Copyright © 2018 Speech Technology Center. All rights reserved.
//

#import "OPUIVerifyAddFaceForStaticVoiceService.h"

#import "CIImage+Extra.h"

#import <OnePassCore/OnePassCore.h>


@interface OPUIVerifyAddFaceForStaticVoiceService()

@property (nonatomic) id<IOPCTransportProtocol> service;
@property (nonatomic) NSString *user;

@end

@implementation OPUIVerifyAddFaceForStaticVoiceService

-(void)addPhoto:(CIImage *)photo
    withHandler:(OPUIVerifyAddFaceResultBlock)handler {
    __weak typeof(self) weakself = self;
    [self.service startVerificationSession:self.user
                       withCompletionBlock:^(id<IOPCVerificationSessionProtocol> session, NSError *error) {
                           if (error) {
                               handler(nil,error);
                               return;
                           }
                           
                           [weakself.service addVerificationFace:photo.nsData
                                             withCompletionBlock:^(NSDictionary *responceObject, NSError *error) {
                                                 if (error) {
                                                     handler(nil,error);
                                                     return;
                                                 }
                                                 
                                                 handler(nil,nil);
                                             }];
                       }];
}

@end

//
//  OPUIVerifyByFaceService.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 16.11.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import "OPUIVerifyFaceService.h"

#import "CIImage+Extra.h"

#import <OnePassCore/OnePassCore.h>

@interface OPUIVerifyFaceService()

@property (nonatomic) id<IOPCTransportProtocol> service;

@property id<OPUIVerifyFaceViewProtocol> view;

@end

@implementation OPUIVerifyFaceService

-(void)attachView:(id<OPUIVerifyFaceViewProtocol>)view {
    self.view = view;
    
    self.service = self.view.service;
}

-(void)deattachView {
    self.view = nil;
}

-(void)verifyPhoto:(CIImage *)photo
       withHandler:(OPUIVerifyResultBlock)handler {

    __weak typeof(self) weakself = self;
    
    [self.service startVerificationSession:self.view.user
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

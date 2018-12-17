//
//  OPUIVerifyStaticVoicePresenter.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 21.08.2018.
//  Copyright © 2018 Speech Technology Center. All rights reserved.
//

#import "OPUIVerifyStaticVoicePresenter.h"

#import "OPUIVerifyStaticVoiceService.h"
#import "OPUIVerifyVoiceViewProtocol.h"
#import "OPUILoader.h"

@interface OPUIVerifyStaticVoicePresenter ()

@property (nonatomic) id<OPUIVerifyVoiceServiceProtocol> verifyService;
@property (nonatomic) id<OPUIVerifyVoiceViewProtocol> verifyView;

@end

@implementation OPUIVerifyStaticVoicePresenter

-(void)attachView:(id<OPUIVoiceViewProtocol>)view {
    [super attachView:view];
    self.verifyView = (id<OPUIVerifyVoiceViewProtocol>)view;

    [self setupService];
}

-(void)setupService{
    self.verifyService = [[OPUIVerifyStaticVoiceService alloc] init];
    [self.verifyService setService:self.view.service];
    
    [self.verifyService startVerificationForUser:self.verifyView.user
                                     withHandler:^(NSDictionary *result, NSError *error) {
                                         if (error) {
                                             [self.verifyView showError:error];
                                         } else {
                                            // [self  showDigits:result[@"passphrase"]];
                                         }
                                     }];
}

- (void)processVoice:(NSData *)data {
    [self.view showActivity];
    __weak typeof(self) weakself = self;
    [self.verifyService verifyVoice:data
                        withHandler:^(NSDictionary *result, NSError *error) {
                            [weakself.view hideActivity];
                            if (error) {
                                [weakself.view routeToPageWithError:error];
                                return ;
                            }
                            
                            BOOL verified = [result[@"status"] isEqualToString:@"SUCCESS"];
                            [OPUILoader.sharedInstance verifyResultBlock](verified, result);
                        }];
}

@end

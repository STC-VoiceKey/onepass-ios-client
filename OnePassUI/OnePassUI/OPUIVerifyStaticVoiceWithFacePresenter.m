//
//  OPUIVerifyStaticVoiceWithFacePresenter.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 27.08.2018.
//  Copyright © 2018 Speech Technology Center. All rights reserved.
//

#import "OPUIVerifyStaticVoiceWithFacePresenter.h"
#import "OPUIVerifyStaticVoiceWithFaceService.h"
#import "OPUIVerifyStaticVoiceWithFaceProtocol.h"
#import "OPUILoader.h"

@interface OPUIVerifyStaticVoiceWithFacePresenter ()

@property (nonatomic) id<OPUIVerifyStaticVoiceWithFaceServiceProtocol> verifyService;
@property (nonatomic) id<OPUIVerifyStaticVoiceWithFaceProtocol> verifyView;
@end

@implementation OPUIVerifyStaticVoiceWithFacePresenter

-(void)attachView:(id<OPUIVoiceViewProtocol>)view {
    [super attachView:view];
    self.verifyView = (id<OPUIVerifyStaticVoiceWithFaceProtocol>)view;
}

-(void)setupService{
    self.verifyService = [[OPUIVerifyStaticVoiceWithFaceService alloc] init];
    [self.verifyService setService:self.view.service];
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

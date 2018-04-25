//
//  OPUIVerifyByVoicePresenter.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 15.11.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import "OPUIVerifyVoicePresenter.h"
#import "OPUIVerifyVoiceViewProtocol.h"

#import "OPUIVerifyVoiceService.h"
#import "OPUIPassphraseManager.h"
#import "OPUILoader.h"
#import "OPUIAlertViewController.h"

@interface OPUIVerifyVoicePresenter()

@property (nonatomic) id<OPUIVerifyVoiceServiceProtocol> service;
@property (nonatomic) id<OPUIVerifyVoiceViewProtocol> verifyView;
@property (nonatomic) id<IOPUIPassphraseManagerProtocol> passphraseManager;

@end

@interface OPUIVerifyVoicePresenter(Private)

-(void)showDigits:(NSString *)digits;


@end

@implementation OPUIVerifyVoicePresenter

-(void)attachView:(id<OPUIVoiceViewProtocol>)view {
    [super attachView:view];
    self.verifyView = (id<OPUIVerifyVoiceViewProtocol>)view;
    
    self.passphraseManager = [[OPUIPassphraseManager alloc] init];
    
    self.service = [[OPUIVerifyVoiceService alloc] init];
    [self.service setService:self.view.service];
    
    [self.service startVerificationForUser:self.verifyView.user
                               withHandler:^(NSDictionary *result, NSError *error) {
                                   if (error) {
                                       [self.verifyView showError:error];
                                   } else {
                                       [self  showDigits:result[@"passphrase"]];
                                   }
                               }];
}

-(void)processVoice:(NSData *)data{
    [self.view showActivity];
    __weak typeof(self) weakself = self;
    [self.service verifyVoice:data
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

@implementation OPUIVerifyVoicePresenter(Private)

-(void)showDigits:(NSString *)digits {
    NSString *convertedDigits = [self.passphraseManager convertToDigits:digits];
    if (convertedDigits == nil || convertedDigits.length==0) {
        NSError *langError = [NSError errorWithDomain:@"com.speachpro.onepass"
                                                 code:400
                                             userInfo:@{ NSLocalizedDescriptionKey: @"Languages do not match"}];
        [self.view showAlertError:langError];
        [self.view showDigit:digits];
    } else {
        [self.view showDigit:convertedDigits];
    }
}



@end



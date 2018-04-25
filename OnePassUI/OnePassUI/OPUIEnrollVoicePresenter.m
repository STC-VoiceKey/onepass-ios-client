//
//  OPUIEnrollVoicePresenter.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 20.11.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import "OPUIEnrollVoicePresenter.h"
#import "OPUIPassphraseManager.h"

#import "OPUILoader.h"


@interface OPUIEnrollVoicePresenter()

@property (nonatomic) NSUInteger sampleNumber;

@property (nonatomic) id<IOPUIPassphraseManagerProtocol> passphraseManager;

@property (nonatomic) id<OPUIEnrollVoiceViewProtocol> enrollView;

@end

@interface OPUIEnrollVoicePresenter(Private)

-(void)configurePassphraseManager;

@end

@implementation OPUIEnrollVoicePresenter

- (void)attachView:(id<OPUIEnrollVoiceViewProtocol>)view
    numberOfSample:(NSUInteger)sampleNumber {
    [super attachView:view];
    
    self.sampleNumber = sampleNumber;
    
    self.passphraseManager = [[OPUIPassphraseManager alloc] initWithNumberOfSample:sampleNumber];
    [self.view showDigit:self.passphraseManager.digitSequence];
 
    self.enrollView = (id<OPUIEnrollVoiceViewProtocol>)self.view;
}

-(void)processVoice:(NSData *)data {
    __weak typeof(self) weakself = self;
    [weakself.service processVoice:data withPassphrase:weakself.passphraseManager.wordsSequence
                       withHandler:^(NSDictionary *result, NSError *error) {
                           [weakself.view hideActivity];
                           if (error) {
                               [weakself.view showError:error];
                               return;
                           }
                           
                           if (weakself.passphraseManager.numberOfSample != 3) {
                               [weakself.enrollView routeToNextVoice];
                           } else {
                               [OPUILoader.sharedInstance enrollResultBlock]( YES, nil);
                           }
                       }];
}

@end

@implementation OPUIEnrollVoicePresenter(Private)

-(void)configurePassphraseManager{
    [self.voiceManager setPassphraseNumber:[NSNumber numberWithUnsignedInteger:self.passphraseManager.numberOfSample]];
    if([self.voiceManager respondsToSelector:@selector(setPassphrase:)]) {
        [self.voiceManager setPassphrase:self.passphraseManager.wordsSequence];
    }
}

@end

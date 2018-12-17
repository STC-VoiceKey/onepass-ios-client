//
//  OPUIVerifyByVoiceViewController.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 15.11.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import "OPUIVerifyVoiceViewController.h"
#import "OPUIVerifyVoicePresenter.h"
#import "OPUIVerifyVoicePresenterProtocol.h"

@interface OPUIVerifyVoiceViewController ()

@property (nonatomic) id<OPUIVerifyVoicePresenterProtocol> verifyPresenter;

@end

@implementation OPUIVerifyVoiceViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.presenter = [[OPUIVerifyVoicePresenter alloc] initWithVoiceManager:self.captureManager.voiceManager
                                                    withService:self.service];
    self.verifyPresenter  = (id<OPUIVerifyVoicePresenterProtocol>)self.presenter;
}

-(void)processVoice:(NSData *)data {
    
}

@end

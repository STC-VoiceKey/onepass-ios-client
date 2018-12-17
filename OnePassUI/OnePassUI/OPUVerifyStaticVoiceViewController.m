//
//  OPUVerifyStaticVoiceViewController.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 20.08.2018.
//  Copyright © 2018 Speech Technology Center. All rights reserved.
//

#import "OPUVerifyStaticVoiceViewController.h"
#import "OPUIVerifyStaticVoicePresenter.h"

@interface OPUVerifyStaticVoiceViewController ()

@property (nonatomic, weak) id<OPUIVerifyStaticVoicePresenterProtocol> verifyPresenter;

@end

@implementation OPUVerifyStaticVoiceViewController

-(void)viewDidLoad {
    [super viewDidLoad];

    self.presenter = [[OPUIVerifyStaticVoicePresenter alloc] initWithVoiceManager:self.captureManager.voiceManager withService:self.service];
    
    self.verifyPresenter  = (id<OPUIVerifyStaticVoicePresenterProtocol>)self.presenter;
}

-(void)viewWillAppear:(BOOL)animated {
    [self.verifyPresenter attachView:self];
}

@end

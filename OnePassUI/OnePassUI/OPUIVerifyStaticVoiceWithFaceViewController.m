//
//  OPUIVerifyStaticVoiceWithFaceViewController.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 22.08.2018.
//  Copyright © 2018 Speech Technology Center. All rights reserved.
//

#import "OPUIVerifyStaticVoiceWithFaceViewController.h"

#import "OPUIVerifyStaticVoiceWithFacePresenter.h"



@interface OPUIVerifyStaticVoiceWithFaceViewController ()

@property (nonatomic, weak) id<OPUIVerifyStaticVoiceWithFacePresenterProtocol> verifyPresenter;

@end

@implementation OPUIVerifyStaticVoiceWithFaceViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.presenter = [[OPUIVerifyStaticVoiceWithFacePresenter alloc] initWithVoiceManager:self.captureManager.voiceManager withService:self.service];
    
    self.verifyPresenter  = (id<OPUIVerifyStaticVoiceWithFacePresenterProtocol>)self.presenter;
}

-(void)viewWillAppear:(BOOL)animated {
    [self.verifyPresenter attachView:self];
}

@end

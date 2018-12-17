//
//  OPUIEnrollStaticVoiceViewController.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 07.08.2018.
//  Copyright © 2018 Speech Technology Center. All rights reserved.
//

#import "OPUIEnrollStaticVoiceViewController.h"
#import "OPUIEnrollStaticVoicePresenterProtocol.h"
#import "OPUIEnrollStaticVoicePresenter.h"

static NSString *kStaticVoiceSussessSegueIdentifier      = @"kStaticVoiceSussessSegueIdentifier";

@interface OPUIEnrollStaticVoiceViewController()

@property (nonatomic, weak) id<OPUIEnrollStaticVoicePresenterProtocol> enrollPresenter;

@end

@implementation OPUIEnrollStaticVoiceViewController

-(void)viewDidLoad{
    [super viewDidLoad];
 
    self.presenter = [[OPUIEnrollStaticVoicePresenter alloc] initWithVoiceManager:self.captureManager.voiceManager
                                                          withService:self.service];
    self.enrollPresenter  = (id<OPUIEnrollStaticVoicePresenterProtocol>)self.presenter;
}

-(void)routeToNextVoice {
    [self performSegueOnMainThreadWithIdentifier:kStaticVoiceSussessSegueIdentifier];
}

#pragma mark - Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:kStaticVoiceSussessSegueIdentifier]) {
        OPUIEnrollVoiceViewController *vc = (OPUIEnrollStaticVoiceViewController *)segue.destinationViewController;
        vc.numberOfSample = self.numberOfSample + 1;
    }
    
    [super prepareForSegue:segue sender:sender];
}

@end

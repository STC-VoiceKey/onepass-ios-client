//
//  OPUIEnrollVoiceViewController.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 20.11.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import "OPUIEnrollVoiceViewController.h"
#import "OPUIEnrollVoicePresenter.h"
#import "OPUIEnrollVoicePresenterProtocol.h"

static NSString *kVoiceSussessSegueIdentifier      = @"kVoiceSussessSegueIdentifier";

@interface OPUIEnrollVoiceViewController()

@property (nonatomic, weak) IBOutlet UILabel *pageLabel;
@property (nonatomic, weak) id<OPUIEnrollVoicePresenterProtocol> enrollPresenter;

@end

@implementation OPUIEnrollVoiceViewController

-(void)viewDidLoad{
    [super viewDidLoad];

    [self configurePageLabel];
    
    self.presenter = [[OPUIEnrollVoicePresenter alloc] initWith:self.captureManager.voiceManager withService:self.service];
    self.enrollPresenter  = (id<OPUIEnrollVoicePresenterProtocol>)self.presenter;
}

-(void)viewWillAppear:(BOOL)animated {
    [self.enrollPresenter attachView:self numberOfSample:self.numberOfSample];
}

-(void)configurePageLabel{
    if(self.numberOfSample == 0) {
        self.numberOfSample = 1;
    }
    self.pageLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.numberOfSample];
    [self.pageLabel sizeToFit];
}

-(void)routeToNextVoice {
    [self performSegueOnMainThreadWithIdentifier:kVoiceSussessSegueIdentifier];
}

#pragma mark - Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:kVoiceSussessSegueIdentifier]) {
        OPUIEnrollVoiceViewController *vc = (OPUIEnrollVoiceViewController *)segue.destinationViewController;
        vc.numberOfSample = self.numberOfSample + 1;
    }
    
    [super prepareForSegue:segue sender:sender];
}

@end


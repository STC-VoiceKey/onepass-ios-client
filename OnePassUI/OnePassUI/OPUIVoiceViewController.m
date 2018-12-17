//
//  OPUIBaseVoiceRecordViewController.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 22.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPUIVoiceViewController.h"
#import "OPUILoader.h"
#import "UIActivityIndicatorView+Status.h"
#import "OPUIVoiceVisualizerView.h"
#import "OPUIBlockCentisecondsTimer.h"
#import "OPUIEnrollVoicePresenter.h"

#import <OnePassCore/OnePassCore.h>
#import <OnePassCapture/OnePassCapture.h>

#pragma mark - Segue Identifiers
static NSString *kVoiceRecordStoryboardIdentifier  = @"kVoiceRecordStoryboardIdentifier";
static NSString *kExitVoiceSegueIdentifier         = @"kExitVoiceSegueIdentifier";

@interface OPUIVoiceViewController()

#pragma mark - Outlets
@property (nonatomic, weak) IBOutlet UIButton        *startButton;
@property (nonatomic, weak) IBOutlet UILabel         *sequenceLabel;
@property (nonatomic, weak) IBOutlet UIProgressView  *timeProgress;
@property (nonatomic, weak) IBOutlet UIView          *noiseIndicator;
@property (nonatomic, weak) IBOutlet OPUIVoiceVisualizerView *voiceView;

@end

@implementation OPUIVoiceViewController

#pragma mark - Lifecyrcle


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.presenter attachView:self];
}

-(void)viewDidDisappear:(BOOL)animated {
    [self.presenter deattachView];
    [super viewDidDisappear:animated];
}

-(void)applicationDidEnterBackground{
    [self exit];
}

-(void)networkStateChanged:(BOOL)isHostAccessable{
    if (!isHostAccessable) {
        [self exit];
    }
}

#pragma mark - IBActions
-(IBAction)onStart:(id)sender{
    [self.presenter onAction];
 }

- (IBAction)unwindVoiceTryAgain:(UIStoryboardSegue *)unwindSegue{
    [self.startButton setSelected:NO];
}

#pragma mark - OPUIEnrollVoiceRecordViewProtocol

-(void)showActivity {
    [self startActivityAnimating];
}

-(void)hideActivity {
    [self stopActivityAnimating];
}

-(void)showError:(NSError *)error{
    if([error.domain isEqualToString:NSURLErrorDomain]) {
        [self performSegueOnMainThreadWithIdentifier:kExitVoiceSegueIdentifier];
    } else {
        [self showError:error withTitle:@"Give it another voice"];
    }
}

-(void)showWaveView {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.voiceView.hidden = NO;
    });
}

-(void)hideWaveView {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.voiceView.hidden = YES;
    });
}

-(void)hideNoiseIndicator {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.noiseIndicator.hidden = YES;
    });
}

-(void)showNoiseIndicator {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.noiseIndicator.hidden = NO;
    });
}

-(void)showStartState{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.startButton.selected = NO;
    });
}
-(void)showStopState {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.startButton.selected = YES;
    });
}

-(void)disabledStartButton {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.startButton.enabled = NO;
    });
}

-(void)enabledStartButton {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.startButton.enabled = YES;
    });
}

-(void)showDigit:(NSString *)digit {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.sequenceLabel.text = digit;
    });
}

-(void)showProgress:(float)progress {
    self.timeProgress.progress = progress;
}

-(void)routeToPageWithError:(NSError *)error {
    [self showError:error
          withTitle:@"Give it another voice"];
}

-(void)exit {
    [self performSegueOnMainThreadWithIdentifier:kExitVoiceSegueIdentifier];
}

-(id<IOPCVoiceVisualizerProtocol>)visualView {
    return self.voiceView;
}

-(NSString *)user{
    return self.userID;
}

-(void)showAlertError:(NSError *)error{
    __weak typeof(self) weakself = self;
    [OPUIAlertViewController showError:error
                    withViewController:weakself
                               handler:nil];
}

@end

//
//  OPUIVerifyFaceAndVoiceViewController.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 22.11.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import "OPUIVerifyFaceAndVoiceViewController.h"
#import "OPUIIndicatorImageView.h"

#import "OPUIVerifyFaceAndVoicePresenterProtocol.h"
#import "OPUIVerifyFaceAndVoicePresenter.h"

@interface OPUIVerifyFaceAndVoiceViewController ()

@property (nonatomic, weak) IBOutlet OPUIIndicatorImageView   *noisyIndicator;
@property (nonatomic, weak) IBOutlet UILabel                  *digitLabel;
@property (nonatomic, weak) IBOutlet UIProgressView           *timeProgress;

@property (nonatomic) id<OPUIVerifyFaceAndVoicePresenterProtocol> presenter;

@property (nonatomic) IBOutlet UIView *indicatorsContainer;

@end

@implementation OPUIVerifyFaceAndVoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.presenter = [[OPUIVerifyFaceAndVoicePresenter alloc] init];
    self.digitLabel.hidden = YES;
}

-(void)attachView {
    [self.presenter attachView:self];
    
    [self.presenter didOrientationChanged:self.currentOrientation];
}

-(void)viewDidDisappear:(BOOL)animated {
   // [super viewDidDisappear:animated];
    
    [self.presenter deattachView];
}

-(void)hideNoiseIndicator {
    self.noisyIndicator.active = NO;
}

-(void)showNoiseIndicator {
    self.noisyIndicator.active = YES;
}

-(void)configureDigits:(NSString *)digits {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSBundle *bundle = [NSBundle bundleForClass:self.class];
        NSString *localization = NSLocalizedStringFromTableInBundle(@"Pronounce the digits", @"OnePassUILocalizable", bundle, nil);
            self.digitLabel.text = [NSString stringWithFormat:@"%@:\n %@",localization, digits];
    });
}

-(void)showDigits {
     dispatch_async(dispatch_get_main_queue(), ^{
         self.digitLabel.hidden   = NO;
         self.timeProgress.hidden = NO;
     });
}

-(void)hideDigits {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.digitLabel.hidden   = YES;
        self.timeProgress.hidden = YES;
    });
}

-(void)showIndicators {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.indicatorsContainer.hidden = NO;
    });
}

-(void)hideIndicators {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.indicatorsContainer.hidden = YES;
    });
}

-(void)showProgress:(float)progress{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.timeProgress.progress = progress;
    });
}

-(id<IOPCCaptureVoiceManagerProtocol>)voiceManager {
    return self.captureManager.voiceManager;
}

-(IBAction)onCancel:(id)sender {
    [self.presenter didCancel];
}

-(void)showAlertError:(NSError *)error{
    __weak typeof(self) weakself = self;
    [OPUIAlertViewController showError:error
                    withViewController:weakself
                               handler:nil];
}

@end

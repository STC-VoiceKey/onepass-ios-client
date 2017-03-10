//
//  OPUIVerifyCaptureViewController.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 24.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPUIVerifyCaptureViewController.h"
#import "OPUIVerifyIndicatorViewController.h"
#import "UIActivityIndicatorView+Status.h"
#import "OPUIBlockSecondTimer.h"
#import "OPUIAlertViewController.h"
#import "OPUIVerifyCaptureManager.h"
#import "OPUILoader.h"

#import <OnePassCore/OnePassCore.h>
#import <OnePassCapture/OnePassCapture.h>

static NSString *kVideoCaptureTimeoutName           = @"VideoCaptureTimeout";
static NSString *kVerifyIndicatorSegueIdentifier    = @"kVerifyIndicatorSegueIdentifier";

@interface OPUIVerifyCaptureViewController ()

#pragma mark - Outlets
@property (nonatomic, weak) IBOutlet OPCRPreviewView *viewVideoCapture;
@property (nonatomic, weak) IBOutlet UIProgressView  *timeProgress;
@property (nonatomic, weak) IBOutlet UILabel         *sequenceLabel;
@property (nonatomic, weak) IBOutlet UIView          *containerView;
@property (nonatomic, weak) IBOutlet UIView          *viewMaskContainer;

/**
 The instance of the video capture manager
 */
@property (nonatomic) OPUIVerifyCaptureManager       *verifyManager;

/**
 The verification session
 */
@property (nonatomic) id<IOPCVerificationSessionProtocol> session;

/**
 The timer that fires when the video should be finished
 */
@property (nonatomic) OPUIBlockCentisecondsTimer *videoLimitDurationTimer;

/**
 The timer that fires when the face is captured more then the timer value
 */
@property (nonatomic) OPUIBlockSecondTimer       *stabilizationTimer;

/**
 The value of the video duration
 */
@property (nonatomic) NSNumber *timeout;

/**
 The value of theverification score
 */
@property (nonatomic, weak) NSDictionary *score;

/**
 The view controller manages the positioning face indicators
 */
@property (nonatomic, weak) OPUIVerifyIndicatorViewController *indicatorViewController;

@end

@interface OPUIVerifyCaptureViewController(PrivateMethods)

/**
 Displays the label with the verification digits
 */
-(void)showDigitLabel;

/**
 Hides the label with the verification digits
 */
-(void)hideDigitLabel;

/**
 The methods invoked when the verification data added to the server

 @param responceObject The responce data
 @param error The error
 */
-(void)verificationDataAdded:(NSDictionary *)responceObject
                   withError:(NSError *)error;

@end

@interface OPUIVerifyCaptureViewController (InitMethods)

/**
 Initialization methods
 */
-(void)initVideoLimitDurationTimer;
-(void)initStabilizationTimer;
-(void)initVideoCaptureReady2RecordBlock;
-(void)initVideoCaptureLoadDataBlock;
-(void)initStartVerificationSessionBlock;
-(void)initIndicatorReadyBlock;

@end

@implementation OPUIVerifyCaptureViewController

-(void)setSession:(id<IOPCVerificationSessionProtocol>)session{
   _session = session;
    self.verifyManager.passphrase = [session passphrase];
    self.verifyManager.session = session;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.timeout = [NSBundle.mainBundle objectForInfoDictionaryKey:kVideoCaptureTimeoutName];
    self.timeout = @(100*self.timeout.floatValue);
}

-(void)applicationDidEnterBackground{
    [self onCancell:nil];
}

-(void)networkStateChanged:(BOOL)isHostAccessable{
    if (!isHostAccessable) {
        [self onCancell:nil];
    }
}

-(void)viewTimerDidExpared{
    if (!self.verifyManager.isRecording) {
        [self.verifyManager stopNoiseAnalyzer];
        [self.service closeVerification:self.session.verificationSessionID
                    withCompletionBlock:nil];
        dispatch_async( dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.verifyManager = [[OPUIVerifyCaptureManager alloc] init];
    self.verifyManager.videoCaptureManager = [self.captureManager videoManager];
    [self.verifyManager setPreview:self.viewVideoCapture];
    self.verifyManager.service = self.service;
    
    self.verifyManager.activityIndicator = self.activityIndicator;
    
    if(self.indicatorViewController) {
        self.indicatorViewController.frameCaptureManager = self.verifyManager.videoCaptureManager;
        self.indicatorViewController.viewMaskContainer = self.viewMaskContainer;
    }
    
    [self stopActivityAnimating];
    
    [self.verifyManager startRunning];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    [self initVideoLimitDurationTimer];

    [self initVideoCaptureReady2RecordBlock];

    [self initVideoCaptureLoadDataBlock];
    
    [self initStartVerificationSessionBlock];
    
    [self initIndicatorReadyBlock];

}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [self.verifyManager stopRunning];
    
    self.verifyManager.videoCaptureManager = nil;
    self.verifyManager = nil;
    
    self.videoLimitDurationTimer = nil;
    self.stabilizationTimer = nil;
    
    self.indicatorViewController.readyBlock = nil;
}

-(void)dealloc{
    _indicatorViewController.frameCaptureManager = nil;
    _indicatorViewController.readyBlock = nil;
    _indicatorViewController = nil;
    
    _verifyManager.responceBlock = nil;
    _verifyManager = nil;
}

#pragma mark - Navigation
-(IBAction)unwindVerifyRetakeVideo:(UIStoryboardSegue *)unwindSegue{
}

-(IBAction)unwindVerifyCancel:(UIStoryboardSegue *)unwindSegue{
    [self onCancell:nil];
}

-(IBAction)onCancell:(id)sender{
    [self.verifyManager stopRunning];
    [self.verifyManager stopNoiseAnalyzer];
    if ([self.verifyManager isRecording]) {
        self.verifyManager.responceBlock = nil;
        [self.verifyManager stop];
    }
    [self.service closeVerification:self.session.verificationSessionID
                withCompletionBlock:nil];
    dispatch_async( dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:kVerifyIndicatorSegueIdentifier]) {
        if(self.indicatorViewController){
            self.indicatorViewController.readyBlock = nil;
        }
        
        self.indicatorViewController = (OPUIVerifyIndicatorViewController *)segue.destinationViewController;
    }
}

-(void)viewWillTransitionToSize:(CGSize)size
      withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    
    if (self.verifyManager.isRecording) {
        [self.verifyManager setResponceBlock:nil];
        [self.verifyManager stop];
        [self showError: [NSError errorWithDomain:@"com.speachpro.onepass"
                                             code:400
                                         userInfo:@{ NSLocalizedDescriptionKey: @"Do not rotate device during recording"}]
              withTitle:@"Give it another video"];
        [self hideDigitLabel];
    }
    
     [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

@end

@implementation OPUIVerifyCaptureViewController(PrivateMethods)

-(void)hideDigitLabel{
    dispatch_async(dispatch_get_main_queue(),^{
        self.sequenceLabel.text = @"";
        self.sequenceLabel.hidden = YES;
    
        self.timeProgress.hidden = YES;
        self.timeProgress.progress = 0;
        
        self.containerView.hidden = NO;
    });
}

-(void)showDigitLabel{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *localization =  NSLocalizedStringFromTableInBundle(@"Pronounce the digits", @"OnePassUILocalizable",[NSBundle bundleForClass:[self class]], nil);
        
        NSString *displayedPassphrase = [OPCPassphraseManager.sharedInstance passphraseSymbolByLocalizedString:self.session.passphrase];
        
        if(displayedPassphrase == nil || displayedPassphrase.length==0) {
            displayedPassphrase = self.session.passphrase;
        }
        self.sequenceLabel.text = [NSString stringWithFormat:@"%@:\n %@",localization, displayedPassphrase];
        
        self.sequenceLabel.hidden = NO;
        
        self.timeProgress.hidden = NO;
        self.timeProgress.progress = 0 ;
        
        self.containerView.hidden = YES;
    });
}

-(void)verificationDataAdded:(NSDictionary *)responceObject withError:(NSError *)error {
    
    if (error) {
        [self stopActivityAnimating];
        [self.service closeVerification:[self.session verificationSessionID]
                    withCompletionBlock:nil];
        
        if([error.domain isEqualToString:NSURLErrorDomain]){
            [self showErrorOnMainThread:error];
        } else {
            [self showError:error withTitle:@"Give it another video"];
        }
        
    } else {
        __weak typeof(self) weakself = self;
#ifdef DEBUG
        [self.service verifyScore:[self.session verificationSessionID]
              withCompletionBlock:^(NSDictionary *responceObject, NSError *error) {
            weakself.score = [NSDictionary dictionaryWithDictionary:responceObject];
        }];
#endif
        [self.service verify:[self.session verificationSessionID]
         withCompletionBlock:^(NSDictionary *responceObject, NSError *error) {
             [weakself stopActivityAnimating];
             [weakself.service closeVerification:weakself.session.verificationSessionID
                             withCompletionBlock:nil];
             if(!error) {
                 BOOL result = [responceObject[@"status"] isEqualToString:@"SUCCESS"];
                 [OPUILoader.sharedInstance verifyResultBlock](result, responceObject);
             } else {
                 [OPUILoader.sharedInstance verifyResultBlock](NO, @{@"message":error.localizedDescription,
                                                                      @"status":@"error"});
             }
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 [weakself.navigationController dismissViewControllerAnimated:YES completion:nil];
             });
        }];
    }
}

@end

@implementation OPUIVerifyCaptureViewController (InitMethods)

-(void)initVideoLimitDurationTimer{
    __weak typeof(self) weakself = self;
    self.videoLimitDurationTimer = [[OPUIBlockCentisecondsTimer alloc]
                                    initTimerWithProgressBlock:^(float seconds){
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            weakself.timeProgress.progress = seconds*10 / weakself.timeout.floatValue;
                                        });
                                    }
                                    withResultBlock:^(float seconds){
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            weakself.timeProgress.progress = 0 ;
                                        });
                                        
                                        if([weakself.verifyManager isRecording]) {
                                            [weakself startActivityAnimating];
                                            [weakself.verifyManager stop];
                                        }
                                    }];
}

-(void)initStabilizationTimer{
    __weak typeof(self) weakself = self;
    weakself.stabilizationTimer = [[OPUIBlockSecondTimer alloc] initTimerWithProgressBlock:nil
                                                                           withResultBlock:^(float seconds) {
                                                                               [weakself.indicatorViewController stopObserving];
                                                                               [weakself.verifyManager prepare2record];
                                                                           }];
}

-(void)initVideoCaptureReady2RecordBlock{
    __weak typeof(self) weakself = self;
    [self.verifyManager.videoCaptureManager setReady2RecordBlock:^(BOOL status) {
        [weakself showDigitLabel];
        [weakself.verifyManager record];
        [weakself.videoLimitDurationTimer startWithTime:weakself.timeout.floatValue];
        
    }];
}

-(void)initVideoCaptureLoadDataBlock{
    __weak typeof(self) weakself = self;
    
    self.verifyManager.responceBlock = ^(NSDictionary *responceObject, NSError *error){
        [weakself startActivityAnimating];
        [weakself hideDigitLabel];
        
        if (error) {
            if([error.domain isEqualToString:NSURLErrorDomain]) {
                [weakself showError:error];
            } else {
                [weakself showError:error withTitle:@"Give it another video"];
            }
            [weakself stopActivityAnimating];
        } else {
            [weakself verificationDataAdded:responceObject withError:error];
        }
    };
}

-(void)initStartVerificationSessionBlock{
    __weak typeof(self) weakself = self;
    [self.service startVerificationSession:self.userID
                       withCompletionBlock:^(id<IOPCVerificationSessionProtocol> session, NSError *error) {
                           if(!error) {
                               weakself.session = session ;
                               NSString *sequesnce = [OPCPassphraseManager.sharedInstance passphraseSymbolByLocalizedString:weakself.session.passphrase];
                               
                               if (sequesnce == nil || sequesnce.length==0) {
                                   NSError *langError = [NSError errorWithDomain:@"com.speachpro.onepass"
                                                                            code:400
                                                                        userInfo:@{ NSLocalizedDescriptionKey: @"Languages do not match"}];
                                   [self showError:langError];
                               }
                           } else {
                               [self showError:error];
                           }
                       }];
}

-(void)initIndicatorReadyBlock{
    __weak typeof(self) weakself = self;
    self.indicatorViewController.readyBlock = ^(BOOL isReady){
        if(![weakself.activityIndicator isAnimating]) {
            if (isReady) {
                if (![weakself.stabilizationTimer isProcessing]) {
                    if (!weakself.stabilizationTimer) {
                        [weakself initStabilizationTimer];
                    }
                    [weakself.stabilizationTimer startWithTime:1];//50];
                }
            } else {
                if ([weakself.stabilizationTimer isProcessing]) {
                    [weakself.stabilizationTimer stop];
                }
            }
        }
    };
}

-(void)showError:(NSError *)error{
    __weak typeof(self) weakself = self;
    [OPUIAlertViewController showError:error
                    withViewController:weakself
                               handler:^(UIAlertAction *action) {
                                   dispatch_async( dispatch_get_main_queue(), ^{
                                       [weakself.navigationController dismissViewControllerAnimated:YES
                                                                                         completion:nil];
                                   });
                               }];
}

@end

//
//  ViewController.m
//  OpePassOnlineDemo
//
//  Created by Soloshcheva Aleksandra on 14.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPODLoginViewController.h"
#import "OPODAccessDeniedViewController.h"

#import <OnePassUI/OnePassUI.h>
#import <OnePassCoreOnline/OnePassCoreOnline.h>
#import <OnePassCore/OnePassCore.h>

#import "OPODLoginPresenter.h"
#import "OPODSettingsManager.h"
#import <OnePassUI/UITextView+Placeholder.h>

static NSString *kSettingsSegueIdentifier       = @"kSettingsSegueIdentifier";
static NSString *kAccessSegueIdentifier         = @"AccessSegueIdentifier";
static NSString *kSignUpCompleteSegueIdentifier = @"SignUpCompleteSegueIdentifier";

static NSString *kVerifyFailSegueIdentifier    = @"kVerifyFailSegueIdentifier";
static NSString *kVerifySuccessSegueIdentifier = @"kVerifySuccessSegueIdentifier";

@interface OPODLoginViewController ()<UITextViewDelegate>

@property (nonatomic,weak) IBOutlet UIButton      *signInButton;
@property (nonatomic,weak) IBOutlet UIButton      *signUpButton;
@property (nonatomic,weak) IBOutlet OPUITextView  *emailTextView;

@property (nonatomic,weak) IBOutlet NSLayoutConstraint *contentCenterConstraint;

@property (nonatomic) NSDictionary *score;

@property (nonatomic) id<IOPODLoginPresenterProtocol> loginPresenter;

@end

@interface OPODLoginViewController(Keyboard)

-(void)keyboardWillAppeared:(NSNotification *)notification;
-(void)keyboardWillDiappeared:(NSNotification *)notification;

-(void)showKeyboard;
-(void)hideKeyboard;

@end

@interface OPODLoginViewController(Private)

-(void)assemblyPresenter;

@end

@implementation OPODLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    __weak typeof(self) weakself = self;
    [OPUILoader.sharedInstance setEnrollResultBlock:^(BOOL result,NSDictionary *score) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.loginPresenter savePerson2UserdDefaults:self.emailTextView.text];
            [weakself performSegueOnMainThreadWithIdentifier:kSignUpCompleteSegueIdentifier];
        });
    }];

    [OPUILoader.sharedInstance setVerifyResultBlock:^(BOOL result,NSDictionary *score) {
        self.score = [NSDictionary dictionaryWithDictionary:score];
        [weakself performSegueOnMainThreadWithIdentifier:(result) ? kVerifySuccessSegueIdentifier : kVerifyFailSegueIdentifier];
    }];
    
    self.emailTextView.placeholder = NSLocalizedString(@"Enter email", nil);
    [self assemblyPresenter];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setSignOFF];
    [self stopActivityAnimating];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self addNotificationObserverForName:UIKeyboardWillShowNotification
                            withSelector:@selector(keyboardWillAppeared:)];
    [self addNotificationObserverForName:UIKeyboardWillHideNotification
                            withSelector:@selector(keyboardWillDiappeared:)];

    [self showKeyboard];

    [self networkStateChanged:self.service.isHostAccessable];
}

-(void)applicationDidEnterBackground {
    [self hideKeyboard];
}

-(void)applicationWillEnterForeground {
  //  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self showKeyboard];
  //  }
    [self networkStateChanged:self.service.isHostAccessable];
}

-(void)networkStateChanged:(BOOL)isHostAccessable{
    if (!isHostAccessable) {
        NSError *error = [NSError errorWithDomain:@"com.speachpro.onepass"
                                             code:500
                                         userInfo:@{ NSLocalizedDescriptionKey:NSLocalizedString(@"Server not respond",nil) }];
        [self showError:error];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.loginPresenter updateNetworkingState:isHostAccessable];
    });
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    
    [self hideKeyboard];
    
    [self removeObserverForName:UIKeyboardWillShowNotification];
    [self removeObserverForName:UIKeyboardWillHideNotification];
}

-(void)showUser:(NSString *)user{
    self.emailTextView.text = user;
}

-(void)startActivityAnimating {
    [super startActivityAnimating];
    [self  setSignOFF];
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [self hideKeyboard];
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            [self showKeyboard];
        } else {
            [self hideKeyboard];
        }
     } completion:nil];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}


#pragma mark - Navigation
-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    
    if ([identifier isEqualToString:kSettingsSegueIdentifier]) {
        NSString *user = [NSString stringWithString:self.emailTextView.text];
        [self.loginPresenter savePerson2UserdDefaults:user];
    }
    return YES;
}

-(void)showAccessResourceWarningWithHandler:(void (^)(UIAlertAction *action))handler{
    [OPUIAlertViewController showWarning:NSLocalizedString(@"To take a photo, a voice and a video we need to access your camera and microphone",nil)
                              withHeader:NSLocalizedString(@"Access to Your Camera and Microphone", nil)
                      withViewController:self
                           cancelHandler:nil
                         settingsHandler:handler];
}

#pragma mark -  UITextViewDelegate <NSObject>

- (BOOL)textViewShouldClear:(UITextField *)textField{
    self.emailTextView.text = @"";
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if( [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location == NSNotFound ) {
        return YES;
    }
    
    [self hideKeyboard];
    if(self.signInButton.isEnabled) {
        [self onSignIN:nil];
    } else {
        if (self.signUpButton.isEnabled) {
            [self onSignUP:nil];
        }
    }
    
    return NO;
}

- (void)textViewDidChange:(UITextView *)textView {
    NSString *user = [self.emailTextView.text stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
    [self.loginPresenter updateUser:user];
}

-(void)hideValidationMessage{
    [self.emailTextView hideValidationMessage];
}
-(void)showValidationMessage{
    [self.emailTextView showValidationMessage:NSLocalizedString(@"Not valid email", nil)];
}

#pragma mark - Navigation
-(IBAction)onSignIN:(id)sender{
    [self hideKeyboard];
    [self.loginPresenter prepareUserToSignIn:self.emailTextView.text];
}

-(IBAction)onSignUP:(id)sender{
    [self hideKeyboard];
    [self.loginPresenter prepareUserToSignUp:self.emailTextView.text];
}

- (IBAction)unwindExit:(UIStoryboardSegue *)unwindSegue{
    id<IOPODSettingsManagerProtocol> settingsManager = [[OPODSettingsManager alloc] init];
    [self.service setServerURL:settingsManager.serverURL];
    [self.service setSessionData:settingsManager.cryptedSessionData];
}

- (IBAction)unwindSettings:(UIStoryboardSegue *)unwindSegue{
    id<IOPODSettingsManagerProtocol> settingsManager = [[OPODSettingsManager alloc] init];
    [self.service setServerURL:settingsManager.serverURL];
    [self.service setSessionData:settingsManager.cryptedSessionData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:kVerifyFailSegueIdentifier]) {
        OPODAccessDeniedViewController *vc = (OPODAccessDeniedViewController *)segue.destinationViewController;
        vc.score = self.score;
    }
}

-(void)setSignUP{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.signInButton.enabled = NO;
        self.signUpButton.enabled = YES;
    });
}
-(void)setSignIN{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.signInButton.enabled = YES;
        self.signUpButton.enabled = NO;
    });
}

-(void)setSignOFF{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.signInButton.enabled = NO;
        self.signUpButton.enabled = NO;
    });
}

-(void)startEnroll{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *vc = [OPUILoader.sharedInstance enrollUILoadWithService:self.service
                                                               withCaptureManager:self.captureManager];
        [self.navigationController pushViewController:vc
                                             animated:YES];
    });
}

-(void)startVerify{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *vc = [OPUILoader.sharedInstance verifyUILoadWithService:self.service
                                                               withCaptureManager:self.captureManager];
        [self.navigationController pushViewController:vc
                                             animated:YES];
    });
}

-(void)showError:(NSError *)error{
    dispatch_async(dispatch_get_main_queue(), ^{
        [OPUIAlertViewController showError:error
                        withViewController:self
                                   handler:nil];
    });
}

-(void)showWarning:(NSString *)warning{
    dispatch_async(dispatch_get_main_queue(), ^{
        [OPUIAlertViewController showWarning:warning
                          withViewController:self
                                     handler:nil];
    });
}

-(void)stopActivityAnimatingAndShowError:(NSError *)error{
    [self stopActivityAnimating];
    [self showError:error];
}

@end

@implementation OPODLoginViewController(Private)

-(void)assemblyPresenter{
    self.loginPresenter = [[OPODLoginPresenter alloc] init];
    [self.loginPresenter attachView:(id<IOPODLoginViewProtocol,IOPODLoginButtonViewProtocol>)self];
    [self.loginPresenter setService:self.service];
    [self.loginPresenter setCaptureManager:self.captureManager];
}

@end

@implementation OPODLoginViewController(Keyboard)

-(void)keyboardWillAppeared:(NSNotification *)notification{
    if ((UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) && UIDeviceOrientationIsLandscape(UIDevice.currentDevice.orientation)) {
        self.contentCenterConstraint.constant = -75;
        [UIView animateWithDuration:0.25 animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}

-(void)keyboardWillDiappeared:(NSNotification *)notification{
    if ((UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) && UIDeviceOrientationIsLandscape(UIDevice.currentDevice.orientation)) {
        self.contentCenterConstraint.constant = 0;
        [UIView animateWithDuration:0.25 animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}

-(void)showKeyboard{
    if (!self.emailTextView.isFirstResponder) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.emailTextView becomeFirstResponder];
        });
    }
}
-(void)hideKeyboard{
    if (self.emailTextView.isFirstResponder) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.emailTextView resignFirstResponder];
        });
    }
}

@end

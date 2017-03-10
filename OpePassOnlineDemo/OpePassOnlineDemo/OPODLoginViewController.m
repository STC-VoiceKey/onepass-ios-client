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
#import <OnePassCaptureStandard/OnePassCaptureStandard.h>
#import <OnePassCore/OnePassCore.h>

#import "NSString+Email.h"
#import "UIViewController+ResourceAccessUtils.h"

extern NSString *kOnePassUserIDKey;

static NSString *kSignInSegueIdentifier = @"SignInSegueIdentifier";
static NSString *kSignUnSegueIdentifier = @"SignUnSegueIdentifier";
static NSString *kSettingsSegueIdentifier = @"SettingsSegueIdentifier";
static NSString *kAccessSegueIdentifier = @"AccessSegueIdentifier";
static NSString *kSignUpCompleteSegueIdentifier = @"SignUpCompleteSegueIdentifier";

static NSString *kVerifyFailSegueIdentifier    = @"kVerifyFailSegueIdentifier";
static NSString *kVerifySuccessSegueIdentifier = @"kVerifySuccessSegueIdentifier";

@interface OPODLoginViewController ()<UITextFieldDelegate>

@property (nonatomic,weak) IBOutlet UIButton      *signInButton;
@property (nonatomic,weak) IBOutlet UIButton      *signUpButton;
@property (nonatomic,weak) IBOutlet OPUITextField *emailTextField;

@property (nonatomic,weak) IBOutlet NSLayoutConstraint *contentCenterConstraint;

@property (nonatomic,strong) id<IOPCPersonProtocol> person;
@property (nonatomic,strong) id<IOPCTransportProtocol> manager;

@property (nonatomic) NSDictionary *score;

@end

@interface OPODLoginViewController(PrivateMethods)

-(void)setSignUP;
-(void)setSignIN;
-(void)setSignOFF;

-(void)startEnroll;
-(void)startVerify;
-(void)stopActivityAnimatingAndShowError:(NSError *)error;
-(void)showError:(NSError *)error;
-(void)savePerson2UserdDefaults:(NSString *)person;
-(void)resetPerson;

-(void)keyboardWillAppeared:(NSNotification *)notification;
-(void)keyboardWillDiappeared:(NSNotification *)notification;

-(void)showKeyboard;
-(void)hideKeyboard;

-(void)updateControlStates;
-(void)readPerson;

@end

@implementation OPODLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.manager = [[OPCOManager alloc] init];

    __weak typeof(self) weakself = self;
    [OPUILoader.sharedInstance setEnrollResultBlock:^(BOOL result,NSDictionary *score) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself performSegueOnMainThreadWithIdentifier:kSignUpCompleteSegueIdentifier];
        });
    }];

    [OPUILoader.sharedInstance setVerifyResultBlock:^(BOOL result,NSDictionary *score) {
        self.score = [NSDictionary dictionaryWithDictionary:score];
        [weakself performSegueOnMainThreadWithIdentifier:(result) ? kVerifySuccessSegueIdentifier : kVerifyFailSegueIdentifier];
    }];
    
   // self.emailTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
    
    [self.emailTextField addTarget:self action:@selector(onEmailEdited:) forControlEvents:UIControlEventEditingChanged];
}

-(void)viewWillAppear:(BOOL)animated{
    [self setSignOFF];
    [self stopActivityAnimating];
    
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self addNotificationObserverForName:UIKeyboardWillShowNotification
                            withSelector:@selector(keyboardWillAppeared:)];
    
    [self addNotificationObserverForName:UIKeyboardWillHideNotification
                            withSelector:@selector(keyboardWillDiappeared:)];

    
    
    self.emailTextField.text = [NSUserDefaults.standardUserDefaults stringForKey:kOnePassUserIDKey];
    [self showKeyboard];

    [self networkStateChanged:self.manager.isHostAccessable];
}

-(void)applicationDidEnterBackground{
    [self hideKeyboard];
}

-(void)applicationWillEnterForeground{
    [self showKeyboard];
    [self networkStateChanged:self.manager.isHostAccessable];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
    [self hideKeyboard];
    
    [self removeObserverForName:UIKeyboardWillShowNotification];
    [self removeObserverForName:UIKeyboardWillHideNotification];
}

-(void)networkStateChanged:(BOOL)isHostAccessable{
    if (isHostAccessable) {
        [self updateControlStates];
    } else {
        [OPUIAlertViewController showWarning:NSLocalizedString(@"Server not respond", nil)
                          withViewController:self
                                     handler:nil];
        [self setSignOFF];
    }
}



-(void)startActivityAnimating{
    [super startActivityAnimating];
    [self setSignOFF];
    
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    
    [self hideKeyboard];
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self showKeyboard];
     } completion:nil];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}


#pragma mark - Navigation
-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    NSString *user = [NSString stringWithString:self.emailTextField.text];
    if ([identifier isEqualToString:kSettingsSegueIdentifier]) {
        if ([user isValidEmail]) {
            [self savePerson2UserdDefaults:user];
        }
        return YES;
    }
    
    if ([identifier isEqualToString:kAccessSegueIdentifier]) {
        return YES;
    }
    
    if([self isMicrophoneUndetermined] || [self isCameraUndetermined]) {
        if ([self isMicrophoneUndetermined] ) {
             [self askMicPermission];
        }

        if ([self isCameraUndetermined] ) {
            [self askCameraPermission];
        }
        
        return NO;
    }
    
    if (![self isMicrophoneAvailable] || ![self isCameraAvailable]) {

        [self performSegueOnMainThreadWithIdentifier:kAccessSegueIdentifier];
        return NO;
    }
    
    [self hideKeyboard];
    
    if ([user isValidEmail])
    {
        [self.emailTextField hideValidationMessage];
        [self startActivityAnimating];
        __weak typeof(self) weakself = self;
        [self.manager readPerson:user
             withCompletionBlock:^(NSDictionary *responceObject, NSError *error) {
             if(error) {
                 [weakself.manager createPerson:user
                            withCompletionBlock:^(NSDictionary *responceObject, NSError *error) {
                                if(error) {
                                    [weakself stopActivityAnimatingAndShowError:error];
                                } else {
                                    [weakself savePerson2UserdDefaults:user];
                                    [weakself startEnroll];
//                                    [self stopActivityAnimating];
                                }
                }];

             } else {
                 weakself.person = [[OPCOPerson alloc] initWithJSON:responceObject];
                 if([weakself.person isFullEnroll]) {
                     [weakself savePerson2UserdDefaults:[weakself.person userID]];
                     [weakself startVerify];
                 } else {
                     [weakself.manager deletePerson:user
                                withCompletionBlock:^(NSDictionary *responceObject, NSError *error) {
                                    if(error) {
                                        [self stopActivityAnimatingAndShowError:error];
                                    } else {
                                        [weakself.manager createPerson:user
                                                   withCompletionBlock:^(NSDictionary *responceObject, NSError *error) {
                                                       if(error) {
                                                           [weakself stopActivityAnimatingAndShowError:error];
                                                       } else {
                                                           [weakself savePerson2UserdDefaults:user];
                                                           [weakself startEnroll];
                                                       }
                                                   }];
                                    }
                                }];
                 }
             }
         }];
    } else {
        [self.emailTextField showValidationMessage:NSLocalizedString(@"Not valid email", nil)];
    }

    return NO;
}


#pragma mark -  UITextFieldDelegate <NSObject>

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    self.emailTextField.text = @"";
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(!self.activityIndicator.isAnimating) {
        [self shouldPerformSegueWithIdentifier:kSignInSegueIdentifier sender:self];
        return NO;
    }else return YES;
}

-(IBAction)onEmailEdited:(id)sender{
    if([self.emailTextField.text isValidEmail]) {
        [self readPerson];
    } else {
        [self setSignOFF];
    }
}

#pragma mark - Navigation

- (IBAction)unwindExit:(UIStoryboardSegue *)unwindSegue{
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:kVerifyFailSegueIdentifier]) {
        OPODAccessDeniedViewController *vc = (OPODAccessDeniedViewController *)segue.destinationViewController;
        vc.score = self.score;
    }
}

@end


@implementation OPODLoginViewController(PrivateMethods)

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
-(void)stopActivityAnimatingAndShowError:(NSError *)error{
    [self stopActivityAnimating];
    [self showError:error];
}

-(void)showError:(NSError *)error{
    dispatch_async(dispatch_get_main_queue(), ^{
        [OPUIAlertViewController showError:error
                        withViewController:self
                                   handler:nil];
    });
}

-(void)savePerson2UserdDefaults:(NSString *)person{
    [NSUserDefaults.standardUserDefaults setObject:person forKey:kOnePassUserIDKey];
    [NSUserDefaults.standardUserDefaults synchronize];
}

-(void)resetPerson{
    [NSUserDefaults.standardUserDefaults setObject:@"" forKey:kOnePassUserIDKey];
    [NSUserDefaults.standardUserDefaults synchronize];
}

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
    if (!self.emailTextField.isFirstResponder) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.emailTextField becomeFirstResponder];
        });
    }
}
-(void)hideKeyboard{
    if (self.emailTextField.isFirstResponder) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.emailTextField resignFirstResponder];
        });
    }
}

-(void)updateControlStates{
    if (![self.manager isHostAccessable]) {
        [self setSignOFF];
        return;
    }
    
    if(self.emailTextField.text  && (self.emailTextField.text.length > 0)) {
        [self readPerson];
    } else {
        [self setSignUP];
    }
}

-(void)readPerson{
    __weak typeof(self) weakself = self;
    [self startActivityAnimating];
    [self.manager readPerson:self.emailTextField.text
         withCompletionBlock:^(NSDictionary *responceObject, NSError *error) {
             [weakself stopActivityAnimating];
             if(error) {
                 [weakself setSignUP];
                 if([error.domain isEqualToString:NSURLErrorDomain]) {
                     [weakself showError:error];
                 }
             } else {
                 weakself.person = [[OPCOPerson alloc] initWithJSON:responceObject];
                 if(![weakself.person isFullEnroll]) {
                     [weakself setSignUP];
                 } else {
                     [weakself setSignIN];
                 }
             }
         }];
}

@end


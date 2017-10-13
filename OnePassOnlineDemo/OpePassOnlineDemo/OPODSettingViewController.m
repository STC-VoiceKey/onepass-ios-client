//
//  OPODSettingViewController.m
//  OnePassOnlineDemo
//
//  Created by Soloshcheva Aleksandra on 04.07.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPODSettingViewController.h"

#import "OPODSettingsPresenter.h"

#import <OnePassUI/OnePassUI.h>
#import <OnePassCapture/OnePassCapture.h>
#import <OnePassCoreOnline/OnePassCoreOnline.h>
#import <OnePassCore/OnePassCore.h>

@interface OPODSettingViewController ()<UITextFieldDelegate>

@property (nonatomic,weak) IBOutlet UITextView      *urlTextField;
@property (nonatomic,weak) IBOutlet UILabel         *versionLabel;

@property (nonatomic,weak) IBOutlet NSLayoutConstraint *cancelConstraint;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint *removeUserConstraint;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint *ipadCenterConstraint;

@property (nonatomic,weak) IBOutlet UIButton *saveButton;

@property (nonatomic) id<IOPODSettingsPresenter> settingPresenter;

@end

@interface OPODSettingViewController(PrivateMethods)

-(void)keyboardWillAppeared:(NSNotification *)notification;
-(void)keyboardWillDiappeared:(NSNotification *)notification;

-(void)popNavigationViewController;

@end

@implementation OPODSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.settingPresenter = [[OPODSettingsPresenter alloc] init];
    [self.settingPresenter setService:self.service];
    [self.settingPresenter attachView:self];

    [self disableSave];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [self addNotificationObserverForName:UIKeyboardWillShowNotification
                            withSelector:@selector(keyboardWillAppeared:)];
    
    [self addNotificationObserverForName:UIKeyboardWillHideNotification
                            withSelector:@selector(keyboardWillDiappeared:)];
    
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self removeObserverForName:UIKeyboardWillShowNotification];
    [self removeObserverForName:UIKeyboardWillHideNotification];
}

-(IBAction)onRemove:(id)sender {
    [self.settingPresenter removeCurrentUser];
}

-(void)showDeleteUserWarningWithHandler:(void (^)(UIAlertAction *action))handler{
    NSString *warning = [NSString stringWithFormat:NSLocalizedString(@"Are you sure you want to remove user %@?",
                                                                     @"Are you sure you want to remove user {person}"), self.settingPresenter.currentUser];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [OPUIAlertViewController showWarning:warning
                                  withHeader:NSLocalizedString(@"Delete User",nil)
                          withViewController:self
                               cancelHandler:nil
                               deleteHandler:handler];
    });
}

-(void)showDeleteUserResultWarningWithHandler:(void (^)(UIAlertAction *action))handler{
    dispatch_async(dispatch_get_main_queue(), ^{
        [OPUIAlertViewController showWarning:NSLocalizedString(@"The user has been successfully removed", nil)
                          withViewController:self
                                     handler:handler];
    });
}

-(void)showDefaultSettingConfirmationWithHandler:(void (^)(UIAlertAction *action))handler{
    NSString *warning = [NSString stringWithFormat:NSLocalizedString(@"Restore default settings?",nil)];
    dispatch_async(dispatch_get_main_queue(), ^{
        [OPUIAlertViewController showWarning:warning
                                  withHeader:nil
                          withViewController:self
                                   okHandler:handler
                               cancelHandler:nil];
    });
}

-(void)exit {
    [self popNavigationViewController];
}

-(IBAction)onSave:(id)sender {
    [self.settingPresenter saveServerURL:self.urlTextField.text];
}

-(IBAction)onCancel:(id)sender {
    if (self.urlTextField.isFirstResponder) {
        [self.urlTextField resignFirstResponder];
        [self.settingPresenter resetServerURL];
    } else {
        [self popNavigationViewController];
    }
}

-(IBAction)onDefaultSettings:(id)sender{
    [self.settingPresenter backToDefaultSettings];
}

#pragma mark -  UITextViewDelegate <NSObject>

- (BOOL)textViewShouldClear:(UITextField *)textField {
    self.urlTextField.text = @"";
    return YES;
}

- (BOOL)textViewShouldReturn:(UITextView *)textField {
    if (textField==self.urlTextField) {
        [self.settingPresenter saveServerURL:self.urlTextField.text];
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    [self.settingPresenter onURLChanged:self.urlTextField.text];
}

#pragma mark IOPODSettingView
-(void)showVersion:(NSString *)version{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.versionLabel.text = version;
    });
}

-(void)showServerURL:(NSString *)url{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.urlTextField.text = url;
    });
}

-(void)enableSave {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.saveButton.enabled = YES;
    });
}

-(void)disableSave {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.saveButton.enabled = NO;
    });
}

@end

@implementation OPODSettingViewController(PrivateMethods)

-(void)keyboardWillAppeared:(NSNotification *)notification {
    self.cancelConstraint.constant = 250;//(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? 260 : 400;
    self.removeUserConstraint.constant = -100;
    self.ipadCenterConstraint.constant = -100;
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

-(void)keyboardWillDiappeared:(NSNotification *)notification {
    self.cancelConstraint.constant = 20;
    self.removeUserConstraint.constant = 240;
    self.ipadCenterConstraint.constant = 0;
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

-(void)popNavigationViewController {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

@end

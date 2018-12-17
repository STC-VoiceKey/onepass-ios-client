//
//  OPODURLViewController.m
//  OnePassOnlineDemo
//
//  Created by Soloshcheva Aleksandra on 18.10.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import "OPODURLTableViewController.h"
#import <OnePassUI/OnePassUI.h>

#import "IOPODURLProtocol.h"
#import "OPODURLPresenter.h"
#import "OPODSession.h"

@interface OPODURLTableViewController ()<UITextFieldDelegate>

@property (nonatomic) id<IOPODURLPresenterProtocol> presenter;

@property (weak, nonatomic) IBOutlet OPUITextField *urlTextView;
@property (weak, nonatomic) IBOutlet OPUITextField *sessionUrlTextView;

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *domainTextField;

@end

@interface OPODURLTableViewController(Private)

-(id<IOPCSession>)currentData;

@end

@implementation OPODURLTableViewController

#pragma mark - Lifecircle
-(void)viewDidLoad {
    [super viewDidLoad];
    
    [self.urlTextView         addTarget:self action:@selector(onURLChanged)       forControlEvents:UIControlEventEditingChanged];
    [self.sessionUrlTextView  addTarget:self action:@selector(onServerURLChanged) forControlEvents:UIControlEventEditingChanged];

    [self.usernameTextField addTarget:self action:@selector(onChange:)    forControlEvents:UIControlEventEditingChanged];
    [self.passwordTextField addTarget:self action:@selector(onChange:)    forControlEvents:UIControlEventEditingChanged];
    [self.domainTextField   addTarget:self action:@selector(onChange:)    forControlEvents:UIControlEventEditingChanged];
}

-(void)viewWillAppear:(BOOL)animated {
    self.urlTextView.placeholder = NSLocalizedString(@"Enter URL",nil);
    self.sessionUrlTextView.placeholder = NSLocalizedString(@"Enter session URL",nil);
    
    self.presenter = [[OPODURLPresenter alloc] init];
    [self.presenter attachView:self];
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated {
    [self.presenter configureDidAppeared];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.textColor = [UIColor colorWithRed:255.0/255.0
                                                 green:219.0/255.0
                                                  blue:072.0/255.0
                                                 alpha:1.0];
}

#pragma mark - IOPODURLViewProtocol
-(void)showURL:(NSString *)url {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.urlTextView.text = url;
    });
}

-(void)showSessionURL:(NSString *)url {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.sessionUrlTextView.text = url;
    });
}

-(void)showDomain:(NSString *)domain {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.domainTextField.text = domain;
    });
}

-(void)showPassword:(NSString *)password {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.passwordTextField.text = password;
    });
}

-(void)showUsername:(NSString *)username {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.usernameTextField.text = username;
    });
}

- (void)showEmptyFieldWarning {
    [OPUIAlertViewController showWarning:NSLocalizedString(@"All fields must be filled", nil)
                      withViewController:self
                                 handler:nil];
}

-(void)showKeyboard {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.urlTextView becomeFirstResponder];
    });
}

-(void)hideKeyboard {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.urlTextView       resignFirstResponder];
        [self.usernameTextField resignFirstResponder];
        [self.passwordTextField resignFirstResponder];
        [self.domainTextField   resignFirstResponder];
    });
}

- (void)hideValidationMessage {
    [self.urlTextView hideValidationMessage];
}

- (void)showValidationMessage {
    [self.urlTextView showValidationMessage:NSLocalizedString(@"Not valid url",nil)];
}

#pragma mark - IBActions
- (IBAction)onSave:(id)sender {
    [self.presenter saveURL:self.urlTextView.text
              andSessionURL:self.sessionUrlTextView.text
                 andSession:self.currentData];
}

- (IBAction)onDefaultSettings:(id)sender {
    [self.presenter backToDefault];
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldClear:(UITextField *)textField{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.urlTextView.text = @"";
    });
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.presenter onURLChanged:self.urlTextView.text];
    [self.presenter onChange:self.currentData];
    return YES;
}

-(IBAction)onURLChanged {
    [self.presenter onURLChanged:self.urlTextView.text];
}

-(IBAction)onServerURLChanged {
    [self.presenter onSessionURLChanged:self.sessionUrlTextView.text];
}

-(IBAction)onChange:(UITextField *)sender {    
    [self.presenter onChange:self.currentData];
}

@end

@implementation OPODURLTableViewController(Private)

-(id<IOPCSession>) currentData {
    id<IOPCSession> sessionData = [[OPODSession alloc] init];
    
    sessionData.username = self.usernameTextField.text;
    sessionData.password = self.passwordTextField.text;
    sessionData.domain   = self.domainTextField.text;
    
    return sessionData;
}

@end

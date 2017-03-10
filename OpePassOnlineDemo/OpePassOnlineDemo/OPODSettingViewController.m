//
//  OPODSettingViewController.m
//  OnePassOnlineDemo
//
//  Created by Soloshcheva Aleksandra on 04.07.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPODSettingViewController.h"

#import <OnePassUI/OnePassUI.h>
#import <OnePassCapture/OnePassCapture.h>
#import <OnePassCoreOnline/OnePassCoreOnline.h>
#import <OnePassCore/OnePassCore.h>

extern NSString *kOnePassServerURL;
extern NSString *kOnePassUserIDKey;

static NSString *kOnePassLimitNoise = @"kOnePassVoiceNoiseLimit";
static NSString *kVoiceNoiseLimitName = @"VoiceNoiseLimit";


@interface OPODSettingViewController ()<UITextFieldDelegate>

@property (nonatomic,weak) IBOutlet UITextField             *urlTextField;
@property (nonatomic,weak) IBOutlet UITextField             *limitTextField;
@property (nonatomic,weak) IBOutlet UILabel                 *versionLabel;

@property (nonatomic,weak) IBOutlet NSLayoutConstraint *cancelConstraint;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint *ipadCenterConstraint;


@property (nonatomic) id<IOPCTransportProtocol> manager;

@end

@interface OPODSettingViewController(PrivateMethods)

-(void)keyboardWillAppeared:(NSNotification *)notification;
-(void)keyboardWillDiappeared:(NSNotification *)notification;

@end

@implementation OPODSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString * version = [NSBundle.mainBundle objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    NSString * build = [NSBundle.mainBundle objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey];
   
    NSString * versionDescription = [NSBundle.mainBundle objectForInfoDictionaryKey: @"STCVersionDescription"];
    self.versionLabel.text = [NSString stringWithFormat:@"%@ (%@) \n %@",version,build,versionDescription ];
    
    NSString *serverUrlFromDefaults = [NSUserDefaults.standardUserDefaults stringForKey:kOnePassServerURL];
    if (serverUrlFromDefaults && serverUrlFromDefaults.length>0) {
        self.urlTextField.text = [NSString stringWithString:serverUrlFromDefaults];
    }
    else {
        self.urlTextField.text = [NSBundle.mainBundle objectForInfoDictionaryKey:@"ServerUrl"];
    }
    
    float noiseLimitFromDefaults = [NSUserDefaults.standardUserDefaults floatForKey:kOnePassLimitNoise];
    if (noiseLimitFromDefaults && noiseLimitFromDefaults>0) {
        self.limitTextField.text = [NSString stringWithFormat:@"%4.0f",noiseLimitFromDefaults];
    } else {
        NSNumber *numberNoiseLimit = [NSBundle.mainBundle objectForInfoDictionaryKey:kVoiceNoiseLimitName];
        self.limitTextField.text = [NSString stringWithFormat:@"%@",numberNoiseLimit];
    }
    
    self.manager = [[OPCOManager alloc] init];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [self addNotificationObserverForName:UIKeyboardWillShowNotification
                            withSelector:@selector(keyboardWillAppeared:)];
    
    [self addNotificationObserverForName:UIKeyboardWillHideNotification
                            withSelector:@selector(keyboardWillDiappeared:)];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [self removeObserverForName:UIKeyboardWillShowNotification];
    [self removeObserverForName:UIKeyboardWillHideNotification];
}

-(IBAction)onRemove:(id)sender{
    
    NSString *keychainUserID = [NSUserDefaults.standardUserDefaults stringForKey:kOnePassUserIDKey];
    
    __weak typeof(self) weakself = self;
    
    if(keychainUserID && keychainUserID.length>0) {
        [self startActivityAnimating];
        [self.manager deletePerson:keychainUserID
                withCompletionBlock:^(NSDictionary *responceObject, NSError *error) {
             [weakself stopActivityAnimating];

              dispatch_async(dispatch_get_main_queue(), ^{
                  if(error) {
                      [OPUIAlertViewController showError:error
                                 withViewController:self
                                            handler:nil];
                  } else {
                      [OPUIAlertViewController showWarning:NSLocalizedString(@"The user has been successfully removed", nil)
                                   withViewController:self
                                              handler:^(UIAlertAction *action) {
                                                    [self.navigationController popViewControllerAnimated:YES];
                                              }];
                  }
            });
        }];
    }
}

-(IBAction)onCancel:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -  UITextFieldDelegate <NSObject>

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    self.urlTextField.text = @"";
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField==self.urlTextField) {
        [NSUserDefaults.standardUserDefaults setObject:self.urlTextField.text forKey:kOnePassServerURL];
        [NSUserDefaults.standardUserDefaults synchronize];
        self.manager = [[OPCOManager alloc] init];
    }
    
    if (textField==self.limitTextField) {
        [NSUserDefaults.standardUserDefaults setObject:self.limitTextField.text forKey:kOnePassLimitNoise];
        [NSUserDefaults.standardUserDefaults synchronize];
        [self.limitTextField resignFirstResponder];
    }
    
    return YES;
}
@end

@implementation OPODSettingViewController(PrivateMethods)

-(void)keyboardWillAppeared:(NSNotification *)notification{
    self.cancelConstraint.constant = 260;
    self.ipadCenterConstraint.constant = -100;
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
    
}

-(void)keyboardWillDiappeared:(NSNotification *)notification{
    self.cancelConstraint.constant = 20;
    self.ipadCenterConstraint.constant = 0;
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

@end


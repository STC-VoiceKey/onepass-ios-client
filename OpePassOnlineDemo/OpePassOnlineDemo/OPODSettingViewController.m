//
//  OPODSettingViewController.m
//  OnePassOnlineDemo
//
//  Created by Soloshcheva Aleksandra on 04.07.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPODSettingViewController.h"

#import <OnePassUI/OnePassUI.h>
#import <OnePassUICommon/OnePassUICommon.h>
#import <OnePassCoreOnline/OnePassCoreOnline.h>
#import <OnePassCore/OnePassCore.h>

static NSString *kOnePassServerURL = @"kOnePassServerURL";

static NSString *kOnePassUserIDKey    = @"kOnePassOnlineDemoKeyChainKey";

@interface OPODSettingViewController ()<UITextFieldDelegate>

@property (nonatomic,weak) IBOutlet UITextField             *urlTextField;

@property (nonatomic) id<ITransport> manager;

@end

@implementation OPODSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *serverUrlFromDefaults = [[NSUserDefaults standardUserDefaults] stringForKey:kOnePassServerURL];
    if (serverUrlFromDefaults && serverUrlFromDefaults.length>0)
    {
        self.urlTextField.text = [NSString stringWithString:serverUrlFromDefaults];
    }
    else
    {
        self.urlTextField.text = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"ServerUrl"];
    }
    self.manager = [[OPCOManager alloc] init];
}

-(IBAction)onRemove:(id)sender{
    
    NSString *keychainUserID = [[NSUserDefaults standardUserDefaults] stringForKey:kOnePassUserIDKey];
    
    __weak OPODSettingViewController *weakself = self;
    
    if(keychainUserID && keychainUserID.length>0)
    {
        [self startActivityAnimating];
        [self.manager deletePerson:keychainUserID
                withCompletionBlock:^(NSDictionary *responceObject, NSError *error)
         {
             [weakself stopActivityAnimating];

              dispatch_async(dispatch_get_main_queue(), ^{
                  if(error)  {
                      [OPUIAlertViewController showError:error
                                 withViewController:self
                                            handler:nil];
                  }else
                  {
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
    [[NSUserDefaults standardUserDefaults] setObject:self.urlTextField.text forKey:kOnePassServerURL];
    [[NSUserDefaults standardUserDefaults] synchronize];
        self.manager = [[OPCOManager alloc] init];
    return YES;
}
@end

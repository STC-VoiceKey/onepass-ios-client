//
//  ViewController.m
//  OpePassOnlineDemo
//
//  Created by Soloshcheva Aleksandra on 14.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPODLoginViewController.h"


#import <OnePassUI/OnePassUI.h>
#import <OnePassCoreOnline/OnePassCoreOnline.h>
#import <OnePassCaptureResources/OnePassCaptureResources.h>
#import <OnePassCore/OnePassCore.h>

#import "NSString+Email.h"

static NSString *kOnePassUserIDKey    = @"kOnePassOnlineDemoKeyChainKey";

static NSString *kSignInSegueIdentifier = @"SignInSegueIdentifier";
static NSString *kSignUnSegueIdentifier = @"SignUnSegueIdentifier";
static NSString *kSettingsSegueIdentifier = @"SettingsSegueIdentifier";

static NSString *kVerifyFailSegueIdentifier    = @"kVerifyFailSegueIdentifier";
static NSString *kVerifySuccessSegueIdentifier = @"kVerifySuccessSegueIdentifier";

@interface OPODLoginViewController ()<UITextFieldDelegate>

@property (nonatomic,weak) IBOutlet UIButton    *actionButton;
@property (nonatomic,weak) IBOutlet UITextField *emailTextField;
//@property

@property (nonatomic) id<IPerson> person;

@property (nonatomic) id<ITransport> manager;

@end

@interface OPODLoginViewController(PrivateMethods)

-(void)setSignUP;
-(void)setSignIN;
-(void)startEnroll;
-(void)startVerify;
-(void)stopActivityAnimatingAndShowError:(NSError *)error;
-(void)showError:(NSError *)error;
-(void)savePerson2UserdDefaults:(NSString *)person;
-(void)resetPerson;

@end

@implementation OPODLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.manager = [[OPCOManager alloc] init];
    
    [[OPUILoader sharedInstance] setEnrollResultBlock:^(BOOL result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [OPUIAlertViewController showWarning:NSLocalizedString(@"Enrollment is successfully completed", nil)
                              withViewController:self
                                         handler:nil];
        });
    }];
    
    __weak typeof(self) weakself = self;
    [[OPUILoader sharedInstance] setVerifyResultBlock:^(BOOL result) {
        [weakself performSegueOnMainThreadWithIdentifier:(result) ? kVerifySuccessSegueIdentifier : kVerifyFailSegueIdentifier];
    }];
    
    if ([self.manager respondsToSelector:@selector(isHostAccessable)])
    {
        BOOL isHostAccessable = [self.manager isHostAccessable];
        
        if(!isHostAccessable)
        {
           [OPUIAlertViewController showWarning:NSLocalizedString(@"Server not respond", nil)
                              withViewController:self
                                         handler:nil];
            
        }
        
    }

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    NSString *keychainUserID = [[NSUserDefaults standardUserDefaults] stringForKey:kOnePassUserIDKey];
    self.emailTextField.text = keychainUserID; 
    if(keychainUserID  && (keychainUserID.length > 0) )
    {
        //user is exists
        [self.emailTextField resignFirstResponder];
        [self setSignIN];
        [self startActivityAnimating];

        __weak OPODLoginViewController *weakself = self;
        [self.manager readPerson:keychainUserID
            withCompletionBlock:^(NSDictionary *responceObject, NSError *error)
            {
                [weakself stopActivityAnimating];
                if(error)
                {
                    [weakself setSignUP];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if([error.domain isEqualToString:NSURLErrorDomain])
                        {
                            [OPUIAlertViewController showError:error
                                            withViewController:self
                                                       handler:nil];
                        }
                    });
                }
                else
                {
                    weakself.person = [[OPCOPerson alloc] initWithJSON:responceObject];
                    if(![weakself.person isFullEnroll])
                        [weakself setSignUP];
                }
            }];
    }
    else
    {
        [self setSignIN];
        [self.emailTextField resignFirstResponder];
        [self stopActivityAnimating];
    }
}


#pragma mark - Navigation
-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:kSettingsSegueIdentifier]) {
        return YES;
    }
    
    NSString *user = [NSString stringWithString:self.emailTextField.text];
    if ([user isValidEmail])
    {
        [self startActivityAnimating];
        __weak OPODLoginViewController *weakself = self;
        [self.manager readPerson:user
             withCompletionBlock:^(NSDictionary *responceObject, NSError *error)
         {
             if(error)
             {
                 [self setSignUP];
                 [weakself.manager createPerson:user
                            withCompletionBlock:^(NSDictionary *responceObject, NSError *error)
                 {
                     if(error)  [self stopActivityAnimatingAndShowError:error];
                     else{
                         [weakself savePerson2UserdDefaults:user];
                         [self startEnroll];
                     }
                }];

             }else
             {
                 weakself.person = [[OPCOPerson alloc] initWithJSON:responceObject];
                 if([weakself.person isFullEnroll]){
                     [self savePerson2UserdDefaults:[weakself.person userID]];
                     [self startVerify];
                 }
                 else
                 {
                     [weakself.manager deletePerson:user
                                withCompletionBlock:^(NSDictionary *responceObject, NSError *error)
                     {
                         if(error)  [self stopActivityAnimatingAndShowError:error];
                         else
                         {
                             [weakself.manager createPerson:user
                                        withCompletionBlock:^(NSDictionary *responceObject, NSError *error)
                             {
                                 if(error)  [self stopActivityAnimatingAndShowError:error];
                                 else
                                 {
                                     [weakself savePerson2UserdDefaults:user];
                                     [self startEnroll];
                                 }
                             }];
                         }
                    }];
                 }
             }
             
         }];
    }
    else
    {
        UIAlertController *alertController = [OPUIAlertViewController showWarning:NSLocalizedString(@"Not valid email", nil)
                          withViewController:self handler:nil];         
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (alertController) {
                [alertController dismissViewControllerAnimated:YES
                                                    completion:nil];
            }
        });
    }

    
    return NO;
}


#pragma mark -  UITextFieldDelegate <NSObject>

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    self.emailTextField.text = @"";
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self shouldPerformSegueWithIdentifier:kSignInSegueIdentifier sender:self];
    return YES;
}

#pragma mark - Navigation

- (IBAction)unwindExit:(UIStoryboardSegue *)unwindSegue
{
}

@end


@implementation OPODLoginViewController(PrivateMethods)

-(void)setSignUP{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.actionButton setSelected:YES];
    });
}
-(void)setSignIN{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.actionButton setSelected:NO];
    });
}

-(void)startEnroll{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIViewController *vc = [[OPUILoader sharedInstance]
                                enrollUILoadWithService:[[OPCOManager alloc] init]
                                withCaptureManager:[OPCRCaptureResourceManager sharedInstance]];
        
        [self presentViewController:vc animated:YES completion:^{
            [self stopActivityAnimating];
        }];
    });
}

-(void)startVerify{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *vc = [[OPUILoader sharedInstance]
                                verifyUILoadWithService:[[OPCOManager alloc] init]
                                withCaptureManager:[OPCRCaptureResourceManager sharedInstance]];
        [self presentViewController:vc animated:YES completion:^{
            [self stopActivityAnimating];
        }];
        
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
    NSLog(@"save person '%@' to user defaults",person);
    [[NSUserDefaults standardUserDefaults] setObject:person forKey:kOnePassUserIDKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)resetPerson{
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kOnePassUserIDKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end


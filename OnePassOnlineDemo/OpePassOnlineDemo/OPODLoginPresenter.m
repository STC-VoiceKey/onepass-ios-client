//
//  OPODLoginPresenter.m
//  OnePassOnlineDemo
//
//  Created by Soloshcheva Aleksandra on 26.09.17.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import "OPODLoginPresenter.h"

#import <OnePassUI/OnePassUI.h>
#import <OnePassCoreOnline/OnePassCoreOnline.h>
#import <OnePassCore/OnePassCore.h>
#import "OPODPerson.h"

#import "OPODLoginButtonPresenter.h"
#import "NSString+Validation.h"
#import "NSObject+ResourceAccessUtils.h"

static NSString *kOnePassUserIDKey = @"kOnePassUserIDKey_v32";

@interface OPODLoginPresenter()

@property (nonatomic) id<IOPODLoginViewProtocol> loginView;
@property (nonatomic) id<IOPCTransportProtocol>  service;
@property (nonatomic) id<IOPCCaptureManagerProtocol> captureMnager;

@property (nonatomic,strong) id<IOPCPersonProtocol> person;

@property (nonatomic,strong) NSString *currentUser;

@property (nonatomic) id<IOPODLoginButtonPresenterProtocol> buttonPresenter;

@end

@implementation OPODLoginPresenter
-(void)attachView:(id<IOPODLoginViewProtocol,IOPODLoginButtonViewProtocol>)loginView{
    _loginView = loginView;
    
    [self.loginView showUser:self.user];
    self.currentUser = self.user;
    
    self.buttonPresenter = [[OPODLoginButtonPresenter alloc] init];
    [self.buttonPresenter attachView:loginView];
}

-(void)savePerson2UserdDefaults:(NSString *)person{
    [NSUserDefaults.standardUserDefaults setObject:person forKey:kOnePassUserIDKey];
    [NSUserDefaults.standardUserDefaults synchronize];
}

- (void)setCaptureManager:(id<IOPCCaptureManagerProtocol>)captureManager {
    _captureMnager = captureManager;
}

- (void)setService:(id<IOPCTransportProtocol>)service {
    _service = service;
}

-(NSString *)user{
    return [NSUserDefaults.standardUserDefaults stringForKey:kOnePassUserIDKey];
}

-(void)networkStateChanged:(BOOL)isHostAccessable {
    if (!isHostAccessable) {
        [self.loginView showWarning:NSLocalizedString(@"Server not respond", nil)];
        [self.buttonPresenter setStateToOFF];
    }
}

-(void)readPerson:(NSString *)user{
    if(!self.service.isHostAccessable) {
        NSError *error = [NSError errorWithDomain:@"com.speachpro.onepass"
                                             code:500
                                         userInfo:@{ NSLocalizedDescriptionKey:NSLocalizedString(@"Server not respond",nil) }];
        [self.loginView showError:error];
        return;
    }
    
    [self.loginView startActivityAnimating];

    if (self.service.isSessionStarted!=YES) {
        [self startSessionFor:user];
        return;
    }
    
    __weak typeof(self) weakself = self;
    
    [self.service readPerson:user
         withCompletionBlock:^(NSDictionary *responceObject, NSError *error) {
             if(error) {
                 [self.buttonPresenter setStateBasedOnValidEmail:user.isValidEmail];
                 
                 weakself.person = nil;
                 
                 if([error.domain isEqualToString:NSURLErrorDomain]) {
                     [self.buttonPresenter setStateToOFF];
                     [weakself.loginView showError:error];
                 }
             } else {
                 weakself.person = [[OPODPerson alloc] initWithJSON:responceObject];
                 if (weakself.person) {
                     [self.buttonPresenter setStateBasedOnFullEnroll:weakself.person.isFullEnroll];
                 } else {
                     [self.buttonPresenter setStateToOFF];
                 }
             }
             [weakself.loginView stopActivityAnimating];
         }];
}

-(void)startSessionFor:(NSString *)user {
    __weak typeof(self) weakself = self;
    [self.service createSessionWithCompletionBlock:^(NSDictionary *responceObject, NSError *error) {
        if(!error) {
            [weakself readPerson:user];
        } else {
            
            [weakself.loginView stopActivityAnimating];
            if([error.domain isEqualToString:NSURLErrorDomain]) {
                [self.buttonPresenter setStateToOFF];
            }
            [weakself.loginView showError:error];
        }
    }];
}

-(BOOL)isAllPermissionAccessable {
    if([self isMicrophoneUndetermined] || [self isCameraUndetermined]) {
        return NO;
    }
    
    if (![self isMicrophoneAvailable] || ![self isCameraAvailable]) {
        return NO;
    }
    
    return YES;
}

-(void)askAllPermissionsWithHandler:(void (^)(BOOL granted))handler{
    if ([self isMicrophoneUndetermined] ) {
        [self askMicPermissionWithHandler:^(BOOL granted) {
            if (!granted) {
                handler(granted);
                return ;
            }
            if ([self isCameraUndetermined] ) {
                [self askCameraPermissionWithHandler:handler];
                return;
            }
        }];
        return;
    }
    
    if ([self isCameraUndetermined] ) {
        [self askCameraPermissionWithHandler:^(BOOL granted) {
            if (!granted) {
                handler(granted);
                return ;
            }
            if ([self isMicrophoneUndetermined] ) {
                [self askMicPermissionWithHandler:handler];
                return;
            }
        }];
        return;
    }
    
    if (![self isMicrophoneAvailable] || ![self isCameraAvailable]) {
        [self.loginView showAccessResourceWarningWithHandler:^(UIAlertAction *action) {
            [UIApplication.sharedApplication openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
    }
}

static BOOL isProgress = NO;
-(void)updateUser:(NSString *)user {
    self.currentUser = user;
    [self.buttonPresenter setStateToOFF];
    if (!isProgress) {
        isProgress = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
                           [self.loginView hideValidationMessage];
                           if(isProgress) {
                               [self setupUser:self.currentUser];
                           }
                           isProgress = NO;
                    });
    }
}

-(void)setupUser:(NSString *)user{
    if([user isValidEmail]) {
        [self readPerson:user];
        return;
    }

    if (user.length > 0) {
        [self.loginView showValidationMessage];
        [self.buttonPresenter setStateToOFF];
    }
}

-(void)prepareUserToSignIn:(NSString *)user{
    self.currentUser = user;
    [self savePerson2UserdDefaults:user];
    
    if (self.isAllPermissionAccessable) {
        [self.loginView startActivityAnimating];
        [self.loginView startVerify];
    } else {
        [self askAllPermissionsWithHandler:^(BOOL granted) {
            if (granted) {
                [self.loginView startActivityAnimating];
                [self.loginView startVerify];
            }
        }];
    }
}

-(void)prepareUserToSignUp:(NSString *)user{
    self.currentUser = user;
    if (self.isAllPermissionAccessable) {
        [self startEnroll];
    } else {
        [self askAllPermissionsWithHandler:^(BOOL granted) {
            if(granted){
                [self startEnroll];
            }
        }];
    }
}

-(void)startEnroll{
    if(self.person) {
        [self deletePersonAndStartEnroll];
    } else {
        [self createPersonAndStartEnroll];
    }
}

-(void)deletePersonAndStartEnroll{
    [self.loginView startActivityAnimating];
    [self.service deletePerson:self.currentUser
           withCompletionBlock:^(NSDictionary *responceObject, NSError *error) {
                [self createPersonAndStartEnroll];
           }];
}

-(void)createPersonAndStartEnroll{
    [self.loginView startActivityAnimating];
    [self.service createPerson:self.currentUser
           withCompletionBlock:^(NSDictionary *responceObject, NSError *error) {
               if (error) {
                   [self.loginView showError:error];
               } else {
                   [self.loginView startEnroll];
               }
               [self.loginView stopActivityAnimating];
           }];
}

-(void)updateNetworkingState:(BOOL)isHostAccessable{
    if(!isHostAccessable) {
        [self.buttonPresenter setStateToOFF];
    } else {
        [self setupUser:self.currentUser];
    }
}

@end

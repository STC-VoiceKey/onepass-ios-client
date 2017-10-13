//
//  SettingsPresenter.m
//  OnePassOnlineDemo
//
//  Created by Soloshcheva Aleksandra on 21.09.17.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import "OPODSettingsPresenter.h"


/**
 The constant name for the server URL in .plist file
 */
static NSString * _Nonnull kOnePassServerURL   = @"kOnePassRestURL";

/**
 The constant name for the server name in the user defaults store
 */
static NSString * _Nonnull kOnePassUserIDKey   = @"kOnePassOnlineDemoKeyChainKey";

static NSString *kOnePassLimitNoise = @"kOnePassVoiceNoiseLimit";
static NSString *kVoiceNoiseLimitName = @"VoiceNoiseLimit";

@interface OPODSettingsPresenter()

@property (nonatomic,strong) id<IOPODSettingsView> settingView;

@property (nonatomic) id<IOPCTransportProtocol> service;

@property (nonatomic) NSString *previousURL;
@end

@implementation OPODSettingsPresenter

-(void)attachView:(id<IOPODSettingsView>)settingView{
    self.settingView = settingView;
    
    [self.settingView showVersion:self.applicationVersion];
    [self.settingView showServerURL:[NSUserDefaults.standardUserDefaults objectForKey:@"kOnePassServerURL"]];
}

-(NSString *)applicationVersion{
    NSString * version = [NSBundle.mainBundle objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    NSString * build   = [NSBundle.mainBundle objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey];
    
    NSString * versionDescription = [NSBundle.mainBundle objectForInfoDictionaryKey: @"STCVersionDescription"];
    
    return [NSString stringWithFormat:@"%@ (%@) \n %@", version, build, versionDescription ];
}

-(NSString *)serverURL{
    NSString *serverUrlFromDefaults = [NSUserDefaults.standardUserDefaults objectForKey:@"kOnePassServerURL"];
    if (serverUrlFromDefaults && serverUrlFromDefaults.length>0) {
        return serverUrlFromDefaults;
    }
    else {
        return [NSBundle.mainBundle objectForInfoDictionaryKey:@"ServerUrl"];
    }
}

-(NSNumber *)noisyLimit{
    float noiseLimitFromDefaults = [NSUserDefaults.standardUserDefaults floatForKey:kOnePassLimitNoise];
    if (noiseLimitFromDefaults && noiseLimitFromDefaults>0) {
        return [NSNumber numberWithFloat:noiseLimitFromDefaults];
    } else {
        NSNumber *numberNoiseLimit = [NSBundle.mainBundle objectForInfoDictionaryKey:kVoiceNoiseLimitName];
        return numberNoiseLimit;
    }
}

-(void)saveServerURL:(NSString *)url{
    self.previousURL = self.serverURL;
    [self checkServerURLCorrection:url];
}

-(void)checkServerURLCorrection:(NSString *)url{
    [self.settingView startActivityAnimating];
    [self.service changeServerURL:url];
    __weak typeof(self) weakself = self;    
    [self.service createSessionWithCompletionBlock:^(NSDictionary *responceObject, NSError *error) {
        [weakself.settingView stopActivityAnimating];
        if(error) {
            [weakself.settingView showErrorOnMainThread:self.incorrectURLError];

        } else {
            self.previousURL = nil;
            [weakself saveURLToUserDefaults:url];
            [self.settingView exit];
        }
    }];
}

-(NSError *)incorrectURLError{
   return [NSError errorWithDomain:@"com.speachpro.onepass"
                        code:500
                    userInfo:@{ NSLocalizedDescriptionKey:  @"Incorrect URL. Please, enter the correct one." }];
}

-(void)saveURLToUserDefaults:(NSString *)url{
    [NSUserDefaults.standardUserDefaults setObject:url forKey:kOnePassServerURL];
    [NSUserDefaults.standardUserDefaults synchronize];
}

-(void)saveNoisyLimit:(NSString *)limit{
    [NSUserDefaults.standardUserDefaults setObject:limit forKey:kOnePassLimitNoise];
    [NSUserDefaults.standardUserDefaults synchronize];
}

-(void)resetServerURL{
    NSString * url = (self.previousURL) ? self.previousURL : self.serverURL;
    [self.settingView showServerURL:url];
    [self saveURLToUserDefaults:url];
    [self.settingView disableSave];
    
    [self checkServerURLCorrection:url];
}

-(void)backToDefaultSettings{
    __weak typeof(self) weakself = self;
    [self.settingView showDefaultSettingConfirmationWithHandler:^(UIAlertAction *action) {
        NSString *serverUrl = [NSBundle.mainBundle objectForInfoDictionaryKey:@"ServerUrl"];
        [weakself saveServerURL:serverUrl];
    }];
}

-(void)onURLChanged:(NSString *)url{
    
    NSString *serverUrlFromDefaults = [NSUserDefaults.standardUserDefaults stringForKey:kOnePassServerURL];
    BOOL enabled = ![serverUrlFromDefaults isEqualToString:url];
    
    if (enabled) {
        [self.settingView enableSave];
    } else {
        [self.settingView disableSave];
    }
}

-(void)removeCurrentUser{
    if(self.isCurrentUserExists) {
        __weak typeof(self) weakself = self;
        [self.settingView showDeleteUserWarningWithHandler:^(UIAlertAction *action) {
            [weakself.settingView startActivityAnimating];
            [weakself.service deletePerson:weakself.currentUser
                       withCompletionBlock:^(NSDictionary *responceObject, NSError *error) {
                           [weakself.settingView stopActivityAnimating];
                           if(error) {
                               [weakself.settingView showErrorOnMainThread:error];
                           } else {
                               [weakself.settingView showDeleteUserResultWarningWithHandler:^(UIAlertAction *action) {
                                   [weakself.settingView exit];
                               }];
                           }
                       }];
        }];
    }
}

-(NSString *)currentUser {
    return [NSUserDefaults.standardUserDefaults stringForKey:kOnePassUserIDKey];
}

-(BOOL)isCurrentUserExists {
    return ( self.currentUser != nil );
}

@end

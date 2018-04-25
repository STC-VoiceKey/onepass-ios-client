//
//  OPODConfigurationPresenter.m
//  OnePassOnlineDemo
//
//  Created by Soloshcheva Aleksandra on 18.10.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//
#import <OnePassCore/OnePassCore.h>
#import <OnePassCoreOnline/OnePassCoreOnline.h>

#import "OPODConfigurationPresenter.h"
#import "OPODSettingsManager.h"

@interface OPODConfigurationPresenter()

@property (nonatomic) id<IOPCTransportProtocol> service;
@property (nonatomic) id<IOPODSettingsViewProtocol> configView;

@property (nonatomic) id<IOPODSettingsManagerProtocol> configurator;
@property (nonatomic)  NSMutableDictionary *modalities;

@end

@interface OPODConfigurationPresenter(Private)

-(NSError *)errorWithMessage:(NSString *)message;
-(void)startingValidation ;
-(void)handlingError:(NSError *)error;

-(void)changeModality:(NSString *)modality withValue:(BOOL)on;

@end

@implementation OPODConfigurationPresenter

-(id)init {
    
    self = [super init];
    if (self) {
        self.configurator = [[OPODSettingsManager alloc] init];
        self.service = [[OPCOManager alloc] init];
        self.modalities = [NSMutableDictionary dictionaryWithDictionary:self.configurator.modalities];
    }
    return self;
    
}

- (void)attachView:(id<IOPODSettingsViewProtocol>)configView {
    self.configView = configView;
    
    [self.service setServerURL:self.configurator.serverURL];
    [self.service setSessionData:self.configurator.cryptedSessionData];
    
    [self.configView showURL:self.configurator.serverURL];
    [self.configView showVersion:self.configurator.version];
    [self.configView showUser:self.configurator.user];
    
    [self updateResolutionView];
    [self updateModilitiesView];
    
    [self startingValidation];
}

-(void)deattachView {
    self.configView = nil;
}

-(void)deleteUser:(NSString *)user{
    __weak typeof(self) weakself = self;
    [self.configView showDeleteUserWarningWithHandler:^(UIAlertAction *action) {
        [weakself.configView showActivityView];
        [weakself.service deletePerson:user
                   withCompletionBlock:^(NSDictionary *responceObject, NSError *error) {
                       [weakself.configView hideActivityView];
                       if(error) {
                           [weakself.configView showError:error];
                       } else {
                           [weakself.configView showDeleteUserResultWarningWithHandler:^(UIAlertAction *action) {
                               [weakself.configView exit];
                           }];
                       }
                   }];
    }];
}

-(void)changeFaceModality:(BOOL)onFace {
    [self changeModality:@"face" withValue:onFace];
}
-(void)changeVoiceModality:(BOOL)onVoice {
    [self changeModality:@"voice" withValue:onVoice];
}
-(void)changeLivenessModality:(BOOL)onLiveness {
    [self changeModality:@"liveness" withValue:onLiveness];
}

-(void)saveModalities {
    [self.configurator changeModalities:self.modalities];
}

-(void)updateModilitiesView {
    NSMutableDictionary *modalities = [NSMutableDictionary dictionaryWithDictionary:self.modalities];
    BOOL isFace = [modalities[@"face"] boolValue];
    BOOL isVoice = [modalities[@"voice"] boolValue];
    BOOL isLiveness = [modalities[@"liveness"] boolValue];
    
    [self.configView showFaceModality:isFace];
    [self.configView showVoiceModality:isVoice];
    [self.configView showLivenessModality:isLiveness];

    if(!isFace) {
        [self.configView disableLivenessModality];
        return;
    }
    
    if (!isVoice) {
        [self.configView disableLivenessModality];
        return;
    }
    
    [self.configView enabledLivenessModality];
}

-(void)updateResolutionView {
    if (self.configurator.isSmallResolution) {
        [self.configView setSmallResolution];
    } else {
        [self.configView setLargeResolution];
    }
}

-(void)changeResolution:(BOOL)isSmallResolution {
    [self.configurator changeResolution:isSmallResolution];
}

-(BOOL)isModalitiesValid {
    BOOL isFace  = [self.modalities[@"face"] boolValue];
    BOOL isVoice = [self.modalities[@"voice"] boolValue];
    
    return (isFace || isVoice) ;
}

@end

@implementation OPODConfigurationPresenter(Private)

-(NSError *)errorWithMessage:(NSString *)message {
    return [NSError errorWithDomain:@"com.speachpro.onepass"
                               code:0
                           userInfo:@{ NSLocalizedDescriptionKey: message }];
}

-(void)startingValidation {
    __weak typeof(self) weakself = self;
    [self.service createSessionWithCompletionBlock:^(NSDictionary *responceObject, NSError *error) {
        if(error) {
            [weakself handlingError:error];
        } else {
            [self.configView resetHighlightURL];
        }
    }];
}

-(void)handlingError:(NSError *)error {
    if(error.code == 500) {
        [self.configView highlightURL];
    }
    
    [self.configView showError:error];
}

-(void)changeModality:(NSString *)modality withValue:(BOOL)on {
    self.modalities[modality] = @(on);
    [self updateModilitiesView];
}

@end

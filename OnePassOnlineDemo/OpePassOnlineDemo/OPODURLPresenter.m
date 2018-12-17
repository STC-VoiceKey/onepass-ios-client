//
//  OPODURLPresenter.m
//  OnePassOnlineDemo
//
//  Created by Soloshcheva Aleksandra on 18.10.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//
#import <OnePassCore/OnePassCore.h>
#import <OnePassCoreOnline/OnePassCoreOnline.h>

#import "OPODURLPresenter.h"
#import "OPODSettingsManager.h"

#import "NSString+Validation.h"
#import "OPODSession.h"

@interface OPODURLPresenter()

@property (nonatomic) id<IOPCTransportProtocol>         service;
@property (nonatomic) id<IOPODSettingsManagerProtocol>  configurator;
@property (nonatomic) id<IOPODURLViewProtocol>          view;

@property (nonatomic) id<IOPCSession> sessionData;
@property (nonatomic) NSString        *currentURL;
@property (nonatomic) NSString        *currentSessionURL;

@end

@interface OPODURLPresenter (Private)

-(void)updateView:(id<IOPCSession>) sessionData;
-(BOOL)isEqualToDefault:(id<IOPCSession>)session;

-(void)updateSaveButtonStateWithURL:(NSString *)url
                     withSessionURL:(NSString *)sessionURL
                    withSessionData:(id<IOPCSession>) sessionData;

-(void)updateDefaultButtonStateWithURL:(NSString *)url
                        withSessionURL:(NSString *)sessionURL
                       withSessionData:(id<IOPCSession>) sessionData;

@end

@implementation OPODURLPresenter

-(id)init {
    self = [super init];
    
    if (self) {
        self.configurator = [[OPODSettingsManager alloc] init];
        
        self.service = [[OPCOManager alloc] init];
        self.currentURL = self.configurator.serverURL;
        self.currentSessionURL = self.configurator.sessionServerURL;
        self.sessionData = self.configurator.sessionData;
    }
    
    return self;
}

-(void)attachView:(id<IOPODURLViewProtocol>)urlView {
    self.view = urlView;
    
    [self.view showURL:self.configurator.serverURL];
    [self.view showSessionURL:self.configurator.sessionServerURL];
    
    [self.view hideActivityView];
    
    [self updateView:self.configurator.sessionData];
    
    [self.view disableSave];
    [self updateDefaultButtonStateWithURL:self.configurator.serverURL
                           withSessionURL:self.configurator.sessionServerURL
                          withSessionData:self.configurator.sessionData];
}

-(BOOL)isURLDefault {
    return [self.currentURL isEqualToString:self.configurator.defaultURL];
}

-(BOOL)isSessionURLDefault {
    return [self.currentSessionURL isEqualToString:self.configurator.defaultURL];
}

-(void)configureDidAppeared {
    [self.view showKeyboard];
}

- (void)deattachView {
    self.view = nil;
}

- (void)onURLChanged:(NSString *)url {
    if(![url isValidUrl]) {
        [self.view showValidationMessage];
        [self.view disableSave];
        return;
    }
    
    if ([url isEqualToString:@""]) {
        [self.view disableSave];
        return;
    }
    
    self.currentURL = url;

    [self updateSaveButtonStateWithURL:self.currentURL
                        withSessionURL:self.currentSessionURL
                       withSessionData:self.sessionData];
    [self updateDefaultButtonStateWithURL:self.currentURL
                           withSessionURL:self.currentSessionURL
                          withSessionData:self.sessionData];
}

- (void)onSessionURLChanged:(NSString *)url {
    if(![url isValidUrl]) {
        [self.view showValidationMessage];
        [self.view disableSave];
        return;
    }
    
    if ([url isEqualToString:@""]) {
        [self.view disableSave];
        return;
    }
    
    self.currentSessionURL = url;
    
    [self updateSaveButtonStateWithURL:self.currentURL
                        withSessionURL:self.currentSessionURL
                       withSessionData:self.sessionData];
    [self updateDefaultButtonStateWithURL:self.currentURL
                           withSessionURL:self.currentSessionURL
                          withSessionData:self.sessionData];
}

- (void)onChange:(id<IOPCSession>)session {
    self.sessionData = session;
    [self updateSaveButtonStateWithURL:self.currentURL
                        withSessionURL:self.currentSessionURL
                       withSessionData:self.sessionData];
    [self updateDefaultButtonStateWithURL:self.currentURL
                           withSessionURL:self.currentSessionURL
                          withSessionData:self.sessionData];
}

- (void)backToDefault {
    [self.view showURL:self.configurator.defaultURL];
    [self.view showSessionURL:self.configurator.defaultURL];
    [self updateView:self.configurator.defaultSessionData];
    [self.view disableDefaults];
    [self.view enabledSave];
    [self.view hideValidationMessage];
}

-(void)saveURL:(NSString *)url
 andSessionURL:(NSString *)sessionUrl
    andSession:(id<IOPCSession>)session {
    if ([self.configurator sessionDataHasEmptyFields:session]) {
        [self.view showEmptyFieldWarning];
        return;
    }
    
    if ([url isEqualToString:@""]) {
        [self.view showEmptyFieldWarning];
        return;
    }
    
    if ([sessionUrl isEqualToString:@""]) {
        [self.view showEmptyFieldWarning];
        return;
    }
    
    [self.view showActivityView];
    
    __weak typeof(self) weakself = self;
    
    id<IOPCSession> sessionData = [[OPODSession alloc] init];
    
    sessionData.username = session.username;
    sessionData.domain   = session.domain;
    sessionData.password = session.password;//[self.configurator crypte:session.password];

    [self.service setSessionData:sessionData];
    [self.service setServerURL:self.currentURL];
    [self.service setSessionServerURL:self.currentSessionURL];
    
    [self.service createSessionWithCompletionBlock:^(NSDictionary *responceObject, NSError *error) {
        [weakself.view hideActivityView];
        if(error) {
            [weakself.view showError:error];
        } else {
            [self.configurator changeSessionData:session];
            [self.configurator changeServerURL:url];
            [self.configurator changeSessionServerURL:sessionUrl];
            [weakself.view exit];
        }
    }];
}

- (void)didPasswordClear:(id<IOPCSession>)session {
    [self.view disableSave];
}


- (void)didPasswordReset:(id<IOPCSession>)session {
    [self.view showPassword:self.configurator.sessionData.password];
    if ([self.configurator.sessionData.username isEqualToString:session.username] &&
        [self.configurator.sessionData.domain isEqualToString:session.domain]) {
        [self.view disableSave];
    }
}

- (void)saveURL:(NSString *)url andSession:(id<IOPCSession>)session {
    
}


-(NSError *)incorrectURLError {
    return [NSError errorWithDomain:@"com.speachpro.onepass"
                               code:500
                           userInfo:@{ NSLocalizedDescriptionKey: @"Incorrect URL. Please, enter the correct one." }];
}

@end

@implementation OPODURLPresenter (Private)

-(void)updateView:(id<IOPCSession>) sessionData {
    [self.view showDomain:sessionData.domain];
    [self.view showUsername:sessionData.username];
    [self.view showPassword:sessionData.password];
}

-(BOOL)isEqualToDefault:(id<IOPCSession>)session {
    id<IOPCSession> defaultSession = self.configurator.defaultSessionData;
    
    if ([defaultSession.username isEqualToString:session.username] &&
        [defaultSession.password isEqualToString:session.password] &&
        [defaultSession.domain   isEqualToString:session.domain]) {
        return YES;
    }
    
    return NO;
}

-(void)updateSaveButtonStateWithURL:(NSString *)url
                     withSessionURL:(NSString *)sessionURL
                   withSessionData:(id<IOPCSession>) sessionData {
    if ([self.configurator sessionDataHasEmptyFields:sessionData]) {
        [self.view disableSave];
        return;
    }
    
    if( self.isURLDefault && self.isSessionURLDefault && [self isEqualToDefault:self.sessionData]) {
        [self.view disableSave];
        return;
    }
    
    [self.view enabledSave];
}

-(void)updateDefaultButtonStateWithURL:(NSString *)url
                        withSessionURL:(NSString *)sessionURL
                       withSessionData:(id<IOPCSession>) sessionData {

    if( self.isURLDefault && self.isSessionURLDefault && [self isEqualToDefault:self.sessionData]) {
        [self.view disableDefaults];
        return;
    }
    
    [self.view enabledDefaults];
}

@end

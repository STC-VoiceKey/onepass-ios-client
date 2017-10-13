//
//  IOPODLoginProtocols.h
//  OnePassOnlineDemo
//
//  Created by Soloshcheva Aleksandra on 26.09.17.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OnePassCore/OnePassCore.h>
#import <OnePassCapture/OnePassCapture.h>

#import <UIKit/UIKit.h>

@protocol IOPODLoginViewProtocol <NSObject>

-(void)showUser:(NSString *)user;
-(void)showError:(NSError *)error;
-(void)showWarning:(NSString *)warning;

-(void)showAccessResourceWarningWithHandler:(void (^)(UIAlertAction *action))handler;

-(void)startActivityAnimating;
-(void)stopActivityAnimating;

-(void)startEnroll;
-(void)startVerify;

-(void)hideValidationMessage;
-(void)showValidationMessage;

@end

@protocol IOPODLoginButtonViewProtocol <NSObject>
@required
-(void)setSignUP;
-(void)setSignIN;
-(void)setSignOFF;
@end

@protocol IOPODLoginPresenterProtocol <NSObject>

-(void)attachView:(id<IOPODLoginViewProtocol,IOPODLoginButtonViewProtocol>)loginView;

-(void)setService:(id<IOPCTransportProtocol>)service;
-(void)setCaptureManager:(id<IOPCCaptureManagerProtocol>)captureManager;

-(void)savePerson2UserdDefaults:(NSString *)person;

-(BOOL)isAllPermissionAccessable;

-(void)updateUser:(NSString *)user;
-(void)setupUser:(NSString *)user;

-(void)prepareUserToSignIn:(NSString *)user;
-(void)prepareUserToSignUp:(NSString *)user;

-(void)updateNetworkingState:(BOOL)isHostAccessable;

@end

@protocol IOPODLoginButtonPresenterProtocol <NSObject>

-(void)attachView:(id<IOPODLoginButtonViewProtocol>)loginView;

-(void)setStateToOFF;
-(void)setStateBasedOnFullEnroll:(BOOL)isFullEnroll;
-(void)setStateBasedOnPersonExists:(BOOL)isFullEnroll;
-(void)setStateBasedOnValidEmail:(BOOL)isValidEmail;

@end



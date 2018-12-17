//
//  IOPODConfigurationProtocol.h
//  OnePassOnlineDemo
//
//  Created by Soloshcheva Aleksandra on 17.10.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OnePassCore/OnePassCore.h>
#import <UIKit/UIKit.h>

#import "IOPODBaseSettingsProtocols.h"

@protocol IOPODSettingsViewProtocol <IOPODSettingBaseViewProtocol>

-(void)showVersion:(NSString *)version;
-(void)showURL:(NSString *)url;

-(void)showUser:(NSString *)user;

-(void)showFaceModality:(BOOL)isFace;
-(void)showVoiceModality:(BOOL)isVoice;
-(void)showStaticVoiceModality:(BOOL)isStaticVoice;
-(void)showLivenessModality:(BOOL)isLiveness;

-(void)showModalityWarning;

-(void)enabledFaceModality;
-(void)enabledVoiceModality;
-(void)enabledStaticVoiceModality;
-(void)enabledLivenessModality;

-(void)disableFaceModality;
-(void)disableVoiceModality;
-(void)disableStaticVoiceModality;
-(void)disableLivenessModality;

-(void)setSmallResolution;
-(void)setLargeResolution;

-(void)highlightURL;

-(void)resetHighlightURL;

-(void)showError:(NSError *)error;

-(void)showDeleteUserWarningWithHandler:(void (^)(UIAlertAction *action))handler;
-(void)showDeleteUserResultWarningWithHandler:(void (^)(UIAlertAction *action))handler;

@end

@protocol IOPODSettingsPresenterProtocol

-(void)attachView:(id<IOPODSettingsViewProtocol>)configView;
-(void)deattachView;

-(void)deleteUser:(NSString *)user;

-(void)changeFaceModality:(BOOL)onFace;
-(void)changeVoiceModality:(BOOL)onVoice;
-(void)changeLivenessModality:(BOOL)onLiveness;
-(void)changeStaticVoiceModality:(BOOL)onStaticVoice;

-(void)saveModalities;

-(BOOL)isModalitiesValid;
-(BOOL)isVoiceModalitiesValid;

-(void)changeResolution:(BOOL)isSmallResolution;

@end

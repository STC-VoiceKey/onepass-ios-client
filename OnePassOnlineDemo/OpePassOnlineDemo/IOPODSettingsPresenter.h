//
//  IOPODSettingsPresenter.h
//  OnePassOnlineDemo
//
//  Created by Soloshcheva Aleksandra on 21.09.17.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IOPODSettingsView.h"
#import <OnePassCore/OnePassCore.h>

@protocol IOPODSettingsPresenter <NSObject>

-(void)setService:(id<IOPCTransportProtocol>)service;

-(void)attachView:(id<IOPODSettingsView>)settingView;

-(void)resetServerURL;
-(void)onURLChanged:(NSString *)url;
-(void)saveServerURL:(NSString *)url;
-(void)backToDefaultSettings;

-(void)removeCurrentUser;
-(NSString *)currentUser;
-(BOOL)isCurrentUserExists;

@end

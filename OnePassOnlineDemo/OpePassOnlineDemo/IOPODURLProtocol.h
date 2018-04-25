//
//  IOPODURLProtocol.h
//  OnePassOnlineDemo
//
//  Created by Soloshcheva Aleksandra on 18.10.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IOPODBaseSettingsProtocols.h"
#import <OnePassCore/OnePassCore.h>

@protocol IOPODURLViewProtocol <IOPODSettingBaseViewProtocol>

-(void)showURL:(NSString *)url;

-(void)showValidationMessage;
-(void)hideValidationMessage;

-(void)showUsername:(NSString *)username;
-(void)showDomain:(NSString *)domain;
-(void)showPassword:(NSString *)username;

-(void)showEmptyFieldWarning;

@end

@protocol IOPODURLPresenterProtocol <IOPODSettingBasePresenterProtocol>

-(void)attachView:(id<IOPODURLViewProtocol>)configView;

-(void)onURLChanged:(NSString *)url;
-(void)onChange:(id<IOPCSession>)session;

-(void)didPasswordReset:(id<IOPCSession>)session;
-(void)didPasswordClear:(id<IOPCSession>)session;
-(void)saveURL:(NSString *)url andSession:(id<IOPCSession>)session;

@end

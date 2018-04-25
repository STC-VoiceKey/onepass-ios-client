//
//  IOPODConfigurationProtocol.h
//  OnePassOnlineDemo
//
//  Created by Soloshcheva Aleksandra on 23.10.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IOPODSettingBaseViewProtocol <NSObject>

@optional

-(void)showError:(NSError *)error;

-(void)exit;

-(void)showKeyboard;
-(void)hideKeyboard;

-(void)showActivityView;
-(void)hideActivityView;

-(void)disableSave;
-(void)enabledSave;

-(void)disableDefaults;
-(void)enabledDefaults;

@end

@protocol IOPODSettingBasePresenterProtocol <NSObject>

-(void)deattachView;

-(void)backToDefault;

-(void)configureDidAppeared;


@end

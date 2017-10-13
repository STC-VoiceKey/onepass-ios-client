//
//  IOPODSettingsView.h
//  OnePassOnlineDemo
//
//  Created by Soloshcheva Aleksandra on 21.09.17.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol IOPODSettingsView <NSObject>

@required
-(void)startActivityAnimating;
-(void)stopActivityAnimating;
-(void)showErrorOnMainThread:(NSError *)error;

-(void)showVersion:(NSString *)version;
-(void)showServerURL:(NSString *)url;

-(void)showDeleteUserWarningWithHandler:(void (^)(UIAlertAction *action))handler;
-(void)showDeleteUserResultWarningWithHandler:(void (^)(UIAlertAction *action))handler;

-(void)showDefaultSettingConfirmationWithHandler:(void (^)(UIAlertAction *action))handler;

-(void)enableSave;
-(void)disableSave;

-(void)exit;

@end

//
//  OPODSettingsTableViewController.m
//  OnePassOnlineDemo
//
//  Created by Soloshcheva Aleksandra on 23.10.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import "OPODSettingBaseTableViewController.h"
#import "IOPODBaseSettingsProtocols.h"
#import <OnePassUI/OnePassUI.h>

@interface OPODSettingBaseTableViewController  ()<IOPODSettingBaseViewProtocol>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *defaultButton;

@property (nonatomic) id<IOPODSettingBasePresenterProtocol> presenter;

@end

@implementation OPODSettingBaseTableViewController

-(void)disableSave {

    dispatch_async(dispatch_get_main_queue(), ^{
        self.saveButton.enabled = NO;
    });
}

-(void)enabledSave {

    dispatch_async(dispatch_get_main_queue(), ^{
        self.saveButton.enabled = YES;
    });
}

-(void)disableDefaults {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.defaultButton.enabled = NO;
    });
}

-(void)enabledDefaults {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.defaultButton.enabled = YES;
    });
}

- (void)hideActivityView {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.activityView stopAnimating];
    });
}

- (void)showActivityView {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.activityView startAnimating];
    });
}

-(void)showError:(NSError *)error{
    dispatch_async(dispatch_get_main_queue(), ^{
        [OPUIAlertViewController showError:error
                        withViewController:self
                                   handler:nil];
    });
}

-(void)exit{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

@end

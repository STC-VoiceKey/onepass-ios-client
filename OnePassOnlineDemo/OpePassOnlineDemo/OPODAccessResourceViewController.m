//
//  OPODAccessResourceViewController.m
//  OnePassOnlineDemo
//
//  Created by Soloshcheva Aleksandra on 17.02.17.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import "OPODAccessResourceViewController.h"
#import <OnePassUI/OnePassUI.h>

@interface OPODAccessResourceViewController ()

@end

@implementation OPODAccessResourceViewController

-(IBAction)onSettings:(id)sender{
    [OPUIAlertViewController showWarning:NSLocalizedString(@"To take a photo, a voice and a video we need to access your camera and microphone",nil)
                              withHeader:NSLocalizedString(@"Access to Your Camera and Microphone", nil)
                      withViewController:self
                               okHandler:^(UIAlertAction *action) {
                                   [UIApplication.sharedApplication openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                               } cancelHandler:^(UIAlertAction *action) {
                                   
                               }];
}

@end

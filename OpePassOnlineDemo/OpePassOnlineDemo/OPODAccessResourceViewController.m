//
//  OPODAccessResourceViewController.m
//  OnePassOnlineDemo
//
//  Created by Soloshcheva Aleksandra on 17.02.17.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import "OPODAccessResourceViewController.h"

@interface OPODAccessResourceViewController ()

@end

@implementation OPODAccessResourceViewController

-(IBAction)onSettings:(id)sender{
    [UIApplication.sharedApplication openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

@end

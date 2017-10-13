//
//  AppDelegate.m
//  OpePassOnlineDemo
//
//  Created by Soloshcheva Aleksandra on 14.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPLDAppDelegate.h"
#import <OnePassCapture/OnePassCapture.h>
#import <OnePassUI/OnePassUI.h>
#import <OnePassCaptureStandard/OnePassCaptureStandard.h>
#import <OnePassCoreOnline/OnePassCoreOnline.h>

#import <CallKit/CallKit.h>

@interface OPLDAppDelegate ()

@end

@implementation OPLDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSString *storyboardName = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) ? @"iPad" : @"iPhone" ;
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:storyboardName bundle:nil];

    self.window.rootViewController = [sb instantiateInitialViewController];
    
    if ([self.window.rootViewController isKindOfClass:[OPUINavigationController class]]) {
        OPUINavigationController *nc = (OPUINavigationController *)self.window.rootViewController;
        nc.captureManager = OPCSCaptureResourceManager.sharedInstance;
        nc.service = [[OPCOManager alloc] init];
        NSLog(@"%@",nc.service);
    }
    [self.window makeKeyAndVisible];
    

    
    return YES;
}

@end

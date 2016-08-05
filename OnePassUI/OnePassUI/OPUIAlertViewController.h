//
//  OPUIAlertViewController.h
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 27.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface OPUIAlertViewController : NSObject

+(UIAlertController *)showWarning:(NSString *)warning withViewController:(UIViewController *)vc handler:(void (^)(UIAlertAction *action))handler;

+(UIAlertController *)showError:(NSError *)error  withViewController:(UIViewController *)vc handler:(void (^)(UIAlertAction *action))handler;

+(UIAlertController *)showWarning:(NSString *)warning
        withHeader:(NSString *)header
withViewController:(UIViewController *)vc
           handler:(void (^)(UIAlertAction *))handler;
@end

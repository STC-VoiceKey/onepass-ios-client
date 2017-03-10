//
//  OPUIAlertViewController.h
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 27.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


/**
 Contains static methods for showing warning messages.
 */
@interface OPUIAlertViewController : NSObject


/**
 Creates the alert view controller displaying the warning message.

 @param warning The warning message.
 @param viewController The view controller which shows the warning message.
 @param handler The block to be executed when the user selects the action.
 @return The alert view controller displays the warning message.
 */
+(UIAlertController *)showWarning:(NSString *)warning
               withViewController:(UIViewController *)viewController
                          handler:(void (^)(UIAlertAction *action))handler;


/**
 Creates the alert view controller displaying the error.

 @param error The error.
 @param viewController The view controller which shows the error.
 @param handler The block to be executed when the user selects the action.
 @return  The alert view controller displays the error.
 */
+(UIAlertController *)showError:(NSError *)error
             withViewController:(UIViewController *)viewController
                        handler:(void (^)(UIAlertAction *action))handler;

/**
 Creates the alert view controller displaying the warning message with the header.

 @param warning The warning message.
 @param header The header of the warning message
 @param viewController The view controller which shows the warning message.
 @param handler The block to be executed when the user selects the action.
 @return The alert view controller displays the warning message.
 */
+(UIAlertController *)showWarning:(NSString *)warning
                       withHeader:(NSString *)header
               withViewController:(UIViewController *)viewController
                          handler:(void (^)(UIAlertAction *))handler;
@end

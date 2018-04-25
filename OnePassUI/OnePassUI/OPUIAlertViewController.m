//
//  OPUIAlertViewController.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 27.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPUIAlertViewController.h"
#import "OPUICorporateColorUtils.h"

@implementation OPUIAlertViewController

+(UIAlertController *)showWarning:(NSString *)warning
               withViewController:(UIViewController *)viewController
                          handler:(void (^ __nullable)(UIAlertAction *action))handler{
    
    UIAlertController *alertController = [self alertControllerWithTitle:nil
                                                                message:warning
                                                         preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", ni)
                               style:UIAlertActionStyleDefault
                               handler:handler];
    
    [alertController addAction:okAction];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [viewController presentViewController:alertController
                         animated:YES
                       completion:nil];
    });

    return alertController;
}

+(UIAlertController *)showError:(NSError *)error
             withViewController:(UIViewController *)viewController
                        handler:(void (^ __nullable)(UIAlertAction *action))handler{
    
    NSString *localizedError       = NSLocalizedStringFromTableInBundle(@"Error", @"OnePassUILocalizable", [NSBundle bundleForClass:[self class]], nil);
    NSString *localizedDescription = NSLocalizedStringFromTableInBundle(error.localizedDescription, @"OnePassUILocalizable", [NSBundle bundleForClass:[self class]], nil);
    
    UIAlertController *alertController = [self alertControllerWithTitle:localizedError
                                                                message:localizedDescription
                                                         preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil)
                                                       style:UIAlertActionStyleDefault
                                                     handler:handler];
    
    [alertController addAction:okAction];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [viewController presentViewController:alertController
                         animated:YES
                       completion:nil];
    });
    
    return alertController;
}

+(UIAlertController *)showWarning:(NSString *)warning
                       withHeader:(NSString *)header
               withViewController:(UIViewController *)viewController
                          handler:(void (^)(UIAlertAction *))handler{
    
    UIAlertController *alertController = [self alertControllerWithTitle:header
                                                                message:warning
                                                         preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", ni)
                                                       style:UIAlertActionStyleDefault
                                                     handler:handler];
    
    [alertController addAction:okAction];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [viewController presentViewController:alertController
                         animated:YES
                       completion:nil];
    });
    return alertController;
}

+(UIAlertController *)showWarning:(NSString *)warning
                       withHeader:(NSString *)header
               withViewController:(UIViewController *)viewController
                    cancelHandler:(void (^)(UIAlertAction *))cancelHandler
                    deleteHandler:(void (^)(UIAlertAction *))deleteHandler{
    
    UIAlertController *alertController = [self alertControllerWithTitle:header
                                                                message:warning
                                                         preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", ni)
                                                       style:UIAlertActionStyleCancel
                                                     handler:cancelHandler];
    [alertController addAction:okAction];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Delete", ni)
                                                           style:UIAlertActionStyleDestructive
                                                         handler:deleteHandler];
    
    [alertController addAction:cancelAction];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [viewController presentViewController:alertController
                                     animated:YES
                                   completion:nil];
    });
    return alertController;
}

+(UIAlertController *)showWarning:(NSString *)warning
                       withHeader:(NSString *)header
               withViewController:(UIViewController *)viewController
                    cancelHandler:(void (^)(UIAlertAction *action))cancelHandler
                  settingsHandler:(void (^)(UIAlertAction *action))settingsHandler{
    
    UIAlertController *alertController = [self alertControllerWithTitle:header
                                                                message:warning
                                                         preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", ni)
                                                       style:UIAlertActionStyleCancel
                                                     handler:cancelHandler];
    [alertController addAction:okAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Settings", ni)
                                                           style:UIAlertActionStyleDefault
                                                         handler:settingsHandler];
    
    [alertController addAction:cancelAction];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [viewController presentViewController:alertController
                                     animated:YES
                                   completion:nil];
    });
    return alertController;
}

+(UIAlertController *)showWarning:(NSString *)warning
                       withHeader:(NSString *)header
               withViewController:(UIViewController *)viewController
                        okHandler:(void (^)(UIAlertAction *action))okHandler
                    cancelHandler:(void (^)(UIAlertAction *action))cancelHandler{
    UIAlertController *alertController = [self alertControllerWithTitle:header
                                                                message:warning
                                                         preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", ni)
                                                           style:UIAlertActionStyleCancel
                                                         handler:cancelHandler];
    [alertController addAction:cancelAction];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Ok", ni)
                                                           style:UIAlertActionStyleDefault
                                                         handler:okHandler];
    
    [alertController addAction:okAction];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [viewController presentViewController:alertController
                                     animated:YES
                                   completion:nil];
    });
    return alertController;
}

+ (UIAlertController *)alertControllerWithTitle:(nullable NSString *)title
                                        message:(nullable NSString *)message
                                 preferredStyle:(UIAlertControllerStyle)preferredStyle{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:preferredStyle];
    
    alertController.view.tintColor = OPUICorporateTurquoise;
    alertController.view.subviews.firstObject.backgroundColor = OPUICorporateColdWhite;
    alertController.view.layer.cornerRadius = 10;
    alertController.view.alpha = 1;
    alertController.view.layer.borderWidth = 1;
    alertController.view.layer.borderColor = OPUICorporateTurquoise.CGColor;
    
    alertController.view.layer.masksToBounds = YES;
    
    if (title) {
        NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:title];
        
        [attrTitle addAttribute:NSForegroundColorAttributeName
                          value:OPUICorporateTurquoise
                          range:NSMakeRange(0, title.length)];
        
        [alertController setValue:attrTitle forKey:@"attributedTitle"];
    }

    if (message) {
        NSMutableAttributedString *attrMessage = [[NSMutableAttributedString alloc] initWithString:message];
        
        [attrMessage addAttribute:NSForegroundColorAttributeName
                            value:OPUICorporateDarkBlue
                            range:NSMakeRange(0, message.length)];
        
        [alertController setValue:attrMessage forKey:@"attributedMessage"];
    }
    
    return alertController;
}

@end

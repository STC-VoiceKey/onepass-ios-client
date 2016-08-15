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

+(UIAlertController *)showWarning:(NSString *)warning withViewController:(UIViewController *)vc handler:(void (^ __nullable)(UIAlertAction *action))handler
{
    
    UIAlertController *alertController = [self
                                          alertControllerWithTitle:nil
                                          message:warning
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", ni)
                               style:UIAlertActionStyleDefault
                               handler:handler];
    
    [alertController addAction:okAction];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [vc presentViewController:alertController
                         animated:YES
                       completion:nil];
    });
    return alertController;

}

+(UIAlertController *)showError:(NSError *)error
             withViewController:(UIViewController *)vc
                        handler:(void (^ __nullable)(UIAlertAction *action))handler
{
    UIAlertController *alertController = [self
                                          alertControllerWithTitle:NSLocalizedStringFromTableInBundle(@"Error", @"OnePassUILocalizable",[NSBundle bundleForClass:[self class]], nil)
                                          message:error.localizedDescription
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", ni)
                               style:UIAlertActionStyleDefault
                               handler:handler];
    
    [alertController addAction:okAction];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [vc presentViewController:alertController
                         animated:YES
                       completion:nil];
    });
    return alertController;
}

+(UIAlertController *)showWarning:(NSString *)warning
        withHeader:(NSString *)header
withViewController:(UIViewController *)vc
           handler:(void (^)(UIAlertAction *))handler{
    UIAlertController *alertController = [self
                                          alertControllerWithTitle:header
                                          message:warning
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", ni)
                               style:UIAlertActionStyleDefault
                               handler:handler];
    
    [alertController addAction:okAction];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [vc presentViewController:alertController
                         animated:YES
                       completion:nil];
    });
    return alertController;

}

+ (UIAlertController *)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:title
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

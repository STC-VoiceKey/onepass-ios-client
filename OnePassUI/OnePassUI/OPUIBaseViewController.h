//
//  OPUIBaseViewController.h
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 21.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OnePassCore/OnePassCore.h>
#import <OnePassCapture/OnePassCapture.h>

/**
 The common based view controller used for all view controllers in the application
 */
@interface OPUIBaseViewController : UIViewController<IOPCTransportableProtocol,
                                                  IOPCIsCaptureManagerProtocol,
                                                UINavigationControllerDelegate>

/**
 The activity indicator shows that the view controller is waiting for the responce
 */
@property (nonatomic,weak) IBOutlet UIActivityIndicatorView *activityIndicator;

/**
 The 'IOPCTransportProtocol' implementation
 */
@property (nonatomic,weak) id<IOPCTransportProtocol>      service;

/**
  The 'IOPCCaptureManagerProtocol' implementation
 */
@property (nonatomic,weak) id<IOPCCaptureManagerProtocol> captureManager;

/**
 The identificator of the current user
 */
@property (nonatomic,readonly) NSString *userID;

/**
 The method which is called when the UIApplicationDidEnterBackgroundNotification message is received.
 Should be overriden in the inheritor.
 */
-(void)applicationDidEnterBackground;

/**
 The method which is called when the UIApplicationWillEnterForegroundNotification message is received.
 Should be overriden in the inheritor.
 */
-(void)applicationWillEnterForeground;

/**
 Starts the animation of the activity indicator.
 */
-(void)startActivityAnimating;

/**
 Stops the animation of the activity indicator.
 */
-(void)stopActivityAnimating;

/**
 Performs the segue on the main thread

 @param identifier The segue identifier
 */
-(void)performSegueOnMainThreadWithIdentifier:(NSString *)identifier;

/**
 Shows the error on the main thread

 @param error The error
 */
-(void)showErrorOnMainThread:(NSError *)error;

/**
 Shows the error with the title in the view controller

 @param error The error
 @param title The header
 */
-(void)showError:(NSError  *)error
       withTitle:(NSString *)title;

/**
 Shows the error with the title in the view controller with the bundle and the localization file
 
 @param error The error
 @param title The header

 @param bundle The bundle
 @param localizationFile The localization file
 */
-(void)showError:(NSError  *)error
       withTitle:(NSString *)title
      withBundle:(NSBundle *)bundle
withLocalizationFile:(NSString *)localizationFile;

/**
 Adds observation to the key path

 @param keyPath The key path
 */
- (void)addObserverForKeyPath:(NSString *)keyPath;

/**
 Adds observation to the notification
 
 @param name The name of notification
 @param selector The selector invoked when the notification event is arrived
 */
-(void)addNotificationObserverForName:(NSNotificationName)name
                         withSelector:(SEL)selector;

/**
 Removes observation of notification

 @param name The name of notification
 */
-(void)removeObserverForName:(NSNotificationName)name;

/**
 Is called when the network status is changed

 @param isHostAccessable YES, if the host is accessable 
 */
-(void)networkStateChanged:(BOOL)isHostAccessable;

@end

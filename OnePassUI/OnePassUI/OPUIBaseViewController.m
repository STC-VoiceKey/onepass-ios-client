//
//  OPUIBaseViewController.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 21.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPUIBaseViewController.h"

#import "OPUIAlertViewController.h"
#import "OPUICorporateColorUtils.h"
#import "OPUIErrorViewController.h"
#import "OPUIPopAnimator.h"
#import "OPUIPushAnimator.h"

#import <CallKit/CallKit.h>

static NSString *kOnePassUserIDKey   = @"kOnePassOnlineDemoKeyChainKey";

static NSString *kIsHostAccessableObservation = @"self.service.isHostAccessable";

@interface OPUIBaseViewController()<CXCallObserverDelegate>

/**
 Shows that the controller observes the UIApplicationDidEnterBackgroundNotification event
 */
@property (nonatomic) BOOL isObservation;

/**
 Observes the incoming call is come
 */
@property (nonatomic) CXCallObserver *callObserver;

@end

@implementation OPUIBaseViewController

#pragma mark - lifecyrcle
-(void)viewDidLoad{
    [super viewDidLoad];
    self.isObservation = NO;
    
    self.navigationController.delegate = self;
    
    self.callObserver = [[CXCallObserver alloc] init];
    [self.callObserver setDelegate:self queue:nil];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self addNotificationObserverForName:UIApplicationDidEnterBackgroundNotification
                            withSelector:@selector(applicationDidEnterBackground)];
    
    [self addNotificationObserverForName:UIApplicationWillEnterForegroundNotification
                            withSelector:@selector(applicationWillEnterForeground)];

    [self addObserverForKeyPath:kIsHostAccessableObservation];
    
    self.isObservation = YES;
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    if (self.isObservation){
        [self removeObserverForName:UIApplicationDidEnterBackgroundNotification];
        [self removeObserverForName:UIApplicationWillEnterForegroundNotification];
 
        [self removeObserver:self forKeyPath:kIsHostAccessableObservation];
        self.isObservation = NO;
    }
    
}

-(void)dealloc{
    if (_isObservation) {
        [NSNotificationCenter.defaultCenter removeObserver:self
                                                      name:UIApplicationDidEnterBackgroundNotification
                                                    object:nil];
        
        [NSNotificationCenter.defaultCenter removeObserver:self
                                                      name:UIApplicationWillEnterForegroundNotification
                                                    object:nil];

        [self removeObserver:self forKeyPath:kIsHostAccessableObservation];
    }
    
    _callObserver = nil;
}

#pragma mark - CXCallObserverDelegate

- (void)callObserver:(CXCallObserver *)callObserver
         callChanged:(CXCall *)call{
    [self applicationDidEnterBackground];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:kIsHostAccessableObservation]) {
        [self networkStateChanged:[self.service isHostAccessable]];
    }
}

-(void)networkStateChanged:(BOOL)isHostAccessable{

}

-(void)applicationDidEnterBackground{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popToRootViewControllerAnimated:YES];
    });
}

-(void)applicationWillEnterForeground{
    [self networkStateChanged:[self.service isHostAccessable]];
}

-(NSString *)userID{
    return [NSUserDefaults.standardUserDefaults objectForKey:kOnePassUserIDKey];
}

#pragma mark - Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    id<IOPCTransportProtocol> service;
    
    if(self.navigationController && [self.navigationController conformsToProtocol:@protocol(IOPCTransportableProtocol)]) {
        id<IOPCTransportableProtocol> vcService =  (id<IOPCTransportableProtocol>) self.navigationController;
        service = [vcService service];
    }
    
    if([segue.destinationViewController conformsToProtocol:@protocol(IOPCTransportableProtocol)] && service) {
        id<IOPCTransportableProtocol> vcService =  (id<IOPCTransportableProtocol>) segue.destinationViewController;
        [vcService setService:service];
    }
    
    [super prepareForSegue:segue sender:sender];
}

#pragma mark - Activiy indicator
-(void)startActivityAnimating{
    if(!self.activityIndicator.isAnimating){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.activityIndicator startAnimating];
        });
    }
}

-(void)stopActivityAnimating{
    if(self.activityIndicator.isAnimating) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.activityIndicator stopAnimating];
        });
    }
}

-(void)performSegueOnMainThreadWithIdentifier:(NSString *)identifier{
     dispatch_async(dispatch_get_main_queue(), ^{
         [self performSegueWithIdentifier:identifier sender:self];
     });
}

-(void)showErrorOnMainThread:(NSError *)error{
    dispatch_async(dispatch_get_main_queue(), ^{
        [OPUIAlertViewController showError:error
                        withViewController:self
                                   handler:nil];
    });
}

-(void)showError:(NSError *)error
        withTitle:(NSString *)title{
    [self showError:error
          withTitle:title
          withBundle:[NSBundle bundleForClass:[self class]]
withLocalizationFile:@"OnePassUILocalizable"];
}

-(void)showError:(NSError *)error
       withTitle:(NSString *)title
      withBundle:(NSBundle *)bundle
withLocalizationFile:(NSString *)localizationFile{
   
    NSString *nibName = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) ? @"OPUIErrorView_iPad" : @"OPUIErrorView_iPhone";
    
    OPUIErrorViewController *vc = [[OPUIErrorViewController alloc] initWithNibName:nibName
                                                                            bundle:[NSBundle bundleForClass:[self class]]];
    
    vc.error = error;
    vc.titleWarning = NSLocalizedStringFromTableInBundle(title, localizationFile, bundle, nil) ;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:vc animated:YES];
    });
}

- (void)addObserverForKeyPath:(NSString *)keyPath{
    [self addObserver:self
           forKeyPath:keyPath
              options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
              context:nil];
}

-(void)addNotificationObserverForName:(NSNotificationName)name
                         withSelector:(SEL)selector{
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:selector
                                               name:name
                                             object:nil];
}

-(void)removeObserverForName:(NSNotificationName)name{
    [NSNotificationCenter.defaultCenter removeObserver:self
                                                  name:name
                                                object:nil];
}


#pragma mark - UINavigationControllerDelegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController*)fromVC
                                                 toViewController:(UIViewController*)toVC{
    
    if (operation == UINavigationControllerOperationPush) {
        return [[OPUIPushAnimator alloc] init];
    }
    
    if (operation == UINavigationControllerOperationPop) {
        return [[OPUIPopAnimator alloc] init];
    }
    
    return nil;
}


@end

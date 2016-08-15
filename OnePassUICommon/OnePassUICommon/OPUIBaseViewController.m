//
//  OPUIBaseViewController.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 21.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPUIBaseViewController.h"
#import "OPUIAlertViewController.h"

static NSString *kOnePassUserIDKey    = @"kOnePassOnlineDemoKeyChainKey";

@interface OPUIBaseViewController()

@property (nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic) BOOL isObservation;

@end

@implementation OPUIBaseViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.isObservation = NO;
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                            selector:@selector(applicationDidEnterBackground)
                                                name:UIApplicationDidEnterBackgroundNotification
                                              object:nil];
    self.isObservation = YES;
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    if (self.isObservation) {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIApplicationDidEnterBackgroundNotification
                                                      object:nil];
        self.isObservation = NO;
    }

}

-(void)dealloc{
    if (_isObservation) {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIApplicationDidEnterBackgroundNotification
                                                      object:nil];
    }
}

-(void)applicationDidEnterBackground{

}

-(NSString *)userID{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kOnePassUserIDKey];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    id<ITransport> service;
    
    if(self.navigationController && [self.navigationController conformsToProtocol:@protocol(ITransportService)])
    {
        id<ITransportService> vcService =  (id<ITransportService>) self.navigationController;
        service = [vcService service];
    }
    
    if([segue.destinationViewController conformsToProtocol:@protocol(ITransportService)] && service){
        id<ITransportService> vcService =  (id<ITransportService>) segue.destinationViewController;
        [vcService setService:service];
    }
    
    [super prepareForSegue:segue sender:sender];
    
}

-(void)startActivityAnimating{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.activityIndicator startAnimating];
    });
}

-(void)stopActivityAnimating{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.activityIndicator stopAnimating];
    });
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



@end

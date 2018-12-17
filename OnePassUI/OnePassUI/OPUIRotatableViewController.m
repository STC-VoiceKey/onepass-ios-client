//
//  OPUIRotatableViewController.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 08.02.17.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import "OPUIRotatableViewController.h"

@interface OPUIRotatableViewController ()

@property (nonatomic,weak) IBOutlet NSLayoutConstraint *widthConstraint;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint *heightConstraint;

@end

@implementation OPUIRotatableViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    [self updateOrientation];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [ NSNotificationCenter.defaultCenter addObserver:self
                                         selector:@selector(orientationChanged)
                                             name:UIDeviceOrientationDidChangeNotification
                                           object:nil];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [ NSNotificationCenter.defaultCenter removeObserver:self
                                                   name:UIDeviceOrientationDidChangeNotification
                                                 object:nil];
}

-(void)orientationChanged{
    [self updateOrientation];
}

-(void)updateOrientation{
    UIInterfaceOrientation interfaceOrientation = UIApplication.sharedApplication.statusBarOrientation;
    
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        self.widthConstraint.constant  = 640;
        self.heightConstraint.constant = 480;
    } else {
        self.widthConstraint.constant  = 480;
        self.heightConstraint.constant = 640;
    }
}

-(OPCAvailableOrientation)currentOrientation {

    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {        
        UIInterfaceOrientation interfaceOrientation = UIApplication.sharedApplication.statusBarOrientation;
        
        if (interfaceOrientation==UIInterfaceOrientationLandscapeRight) {
            return OPCAvailableOrientationRight;
        }
        
        if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft) {
            return OPCAvailableOrientationLeft;
        }
    }    
    return OPCAvailableOrientationUp;
}

@end

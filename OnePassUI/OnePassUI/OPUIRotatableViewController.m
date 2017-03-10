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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateViewConstraints];
}

-(void)viewWillTransitionToSize:(CGSize)size
      withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [self updateViewConstraints];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

-(void)updateViewConstraints{
    [super updateViewConstraints];
    
    if (UIDeviceOrientationIsPortrait(UIDevice.currentDevice.orientation)) {
        self.widthConstraint.constant  = 480;
        self.heightConstraint.constant = 640;
    } else {
        self.widthConstraint.constant  = 640;
        self.heightConstraint.constant = 480;
    }
}

@end

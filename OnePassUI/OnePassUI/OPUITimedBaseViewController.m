//
//  OPUITimedBaseViewController.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 14.02.17.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import "OPUITimedBaseViewController.h"
#import "OPUIBlockSecondTimer.h"

@interface OPUITimedBaseViewController ()

@property (nonatomic) OPUIBlockSecondTimer       *expiredTimer;

@end

@implementation OPUITimedBaseViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    __weak typeof(self) weakself = self;
    self.expiredTimer = [[OPUIBlockSecondTimer alloc] initTimerWithProgressBlock:nil
                                                                 withResultBlock:^(float seconds){
                                                                     [weakself viewTimerDidExpared];
                                                                 }];
    
    [self.expiredTimer startWithTime:180];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    if (self.expiredTimer) {
        [self.expiredTimer stop];
        self.expiredTimer = nil;
    }
}

-(void)viewTimerDidExpared{
    dispatch_async( dispatch_get_main_queue(), ^{
        [self.navigationController popToRootViewControllerAnimated:NO];
    });
}

@end

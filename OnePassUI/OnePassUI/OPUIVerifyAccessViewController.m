//
//  OPUIAccessViewController.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 07.07.16.
//  Copyright © 2016 Soloshcheva Aleksandra. All rights reserved.
//

#import "OPUIVerifyAccessViewController.h"

@interface OPUIVerifyAccessViewController ()

@end

@implementation OPUIVerifyAccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3*NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

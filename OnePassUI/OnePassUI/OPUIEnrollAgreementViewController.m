//
//  OPUIAgreementViewController.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 30.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPUIEnrollAgreementViewController.h"
#import "OPUIAlertViewController.h"

@interface OPUIEnrollAgreementViewController ()

@end

@implementation OPUIEnrollAgreementViewController

- (void)viewDidLoad {
    
    self.dataSource = @[@{ @"image":@"light",       @"cause":@"Find a well lit place"},
                        @{ @"image":@"silence",     @"cause":@"Make sure it's quiet"},
                        @{ @"image":@"sunglasses",  @"cause":@"Take off sunglasses"},
                        @{ @"image":@"otherface",   @"cause":@"Make your ordinary face"},

                        ];
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)applicationDidEnterBackground{
    [self  unwindCancel:nil];
}

-(IBAction)onCancel:(id)sender{
    [self  unwindCancel:nil];
}

-(IBAction)unwindCancel:(UIStoryboardSegue *)unwindSegue{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end

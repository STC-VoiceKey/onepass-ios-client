//
//  OPODAccessDeniedViewController.m
//  OnePassLivenessDemo
//
//  Created by Soloshcheva Aleksandra on 13.10.16.
//  Copyright © 2016 Speech Tehnology Center. All rights reserved.
//

#import "OPODAccessDeniedViewController.h"

@interface OPODAccessDeniedViewController ()

@property (nonatomic,weak) IBOutlet UILabel *scoreLabel;

@end

@implementation OPODAccessDeniedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scoreLabel.text = [NSString stringWithFormat:@"%@\n%@",self.score[@"status"],self.score[@"message"]];
}

@end

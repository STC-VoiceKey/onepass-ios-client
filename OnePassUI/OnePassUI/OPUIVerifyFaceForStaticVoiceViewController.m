//
//  OPUIVerifyFaceForStaticVoiceViewController.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 22.08.2018.
//  Copyright © 2018 Speech Technology Center. All rights reserved.
//

#import "OPUIVerifyFaceForStaticVoiceViewController.h"
#import "OPUIVerifyFaceForStaticVoicePresenter.h"

static NSString *kFromFaceToStaticVoiceSegueIdentifier  = @"kFromFaceToStaticVoiceSegueIdentifier";

@interface OPUIVerifyFaceForStaticVoiceViewController ()

@end

@implementation OPUIVerifyFaceForStaticVoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.presenter = [[OPUIVerifyFaceForStaticVoicePresenter alloc] init];
}

-(void)routeToStaticVoicePage{
    [self performSegueOnMainThreadWithIdentifier:kFromFaceToStaticVoiceSegueIdentifier];
}

@end

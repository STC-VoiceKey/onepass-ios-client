//
//  OPUIEnrollFailVoiceViewController.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 19.07.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPUIEnrollFailVoiceViewController.h"

@implementation OPUIEnrollFailVoiceViewController

static NSString *kFailVoiceSegueIdentifier = @"kFailVoiceSegueIdentifier";

-(void)viewDidLoad{
    self.dataSource = @[@{ @"image":@"silence",   @"cause":@"Too noisy"},
                        @{ @"image":@"poorimage", @"cause":@"Incorrect pronunciation"}
                        ];
    [super viewDidLoad];
}

-(void)applicationDidEnterBackground{
    [self performSegueWithIdentifier:kFailVoiceSegueIdentifier sender:nil];
}

@end

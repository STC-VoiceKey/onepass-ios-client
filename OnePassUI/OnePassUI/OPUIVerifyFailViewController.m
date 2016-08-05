//
//  OPUIVerifyFailViewController.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 19.07.16.
//  Copyright © 2016 Soloshcheva Aleksandra. All rights reserved.
//

#import "OPUIVerifyFailViewController.h"

@implementation OPUIVerifyFailViewController

static NSString *kFailVerifySegueIdentifier = @"kFailVerifySegueIdentifier";

-(void)viewDidLoad{
    self.dataSource = @[@{ @"image":@"eyesclosed", @"cause":@"Eyes closed"},
                        @{ @"image":@"otherface",  @"cause":@"Other faces detection"},
                        @{ @"image":@"sunglasses", @"cause":@"Eyes not found"},
                        @{ @"image":@"poorimage",  @"cause":@"Poor image quality"},
                        @{ @"image":@"noface",     @"cause":@"No face detection"},
                        @{ @"image":@"silence",    @"cause":@"Incorrect pronunciation"}
                        ];
    [super viewDidLoad];
}

-(void)applicationDidEnterBackground{
    [self performSegueWithIdentifier:kFailVerifySegueIdentifier sender:nil];
}

@end

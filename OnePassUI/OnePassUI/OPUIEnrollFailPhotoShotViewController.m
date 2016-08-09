//
//  OPUIEnrollTakeAnotherShotViewController.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 19.07.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPUIEnrollFailPhotoShotViewController.h"

static NSString *kFailPhotoFailSegueIdentifier = @"kFailPhotoFailSegueIdentifier";

@implementation OPUIEnrollFailPhotoShotViewController

-(void)viewDidLoad{
    self.dataSource = @[@{ @"image":@"eyesclosed", @"cause":@"Eyes closed"},
                        @{ @"image":@"otherface",  @"cause":@"Other faces detection"},
                        @{ @"image":@"sunglasses", @"cause":@"Eyes not found"},
                        @{ @"image":@"poorimage",  @"cause":@"Poor image quality"},
                        @{ @"image":@"noface",     @"cause":@"No face detection"}
                        ];
    [super viewDidLoad];
}

-(void)applicationDidEnterBackground{
    [self performSegueWithIdentifier:kFailPhotoFailSegueIdentifier sender:nil];
}


@end

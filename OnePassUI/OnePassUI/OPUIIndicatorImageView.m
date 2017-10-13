//
//  OPUIIndicatorImageView.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 04.10.17.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import "OPUIIndicatorImageView.h"
#import "OPUICorporateColorUtils.h"

@implementation OPUIIndicatorImageView

-(void)setActive:(BOOL)active{
    _active = active;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.image = [self.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.tintColor = !active ? OPUIWhiteWithAlpha(0.4) :  OPUIRedWithAlpha(1);
    });
}

@end

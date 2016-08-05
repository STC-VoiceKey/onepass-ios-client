//
//  OPUIButton.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 23.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPUIButton.h"

@implementation OPUIButton


- (void)drawRect:(CGRect)rect {
    self.layer.borderColor = self.layer.backgroundColor;
    self.layer.cornerRadius = self.bounds.size.height / 2;
    
    [self.layer setMasksToBounds:YES];
}


@end

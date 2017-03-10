//
//  OPUIBorderedView.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 30.01.17.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import "OPUIWhiteBorderView.h"
#import "OPUICorporateColorUtils.h"

@implementation OPUIWhiteBorderView


- (void)drawRect:(CGRect)rect {
    self.layer.borderColor = self.frameColor.CGColor;
    self.layer.borderWidth = self.frameWidth;

    [super drawRect:rect];
}



@end

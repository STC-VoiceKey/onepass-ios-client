//
//  OPUISpacingLabel.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 27.10.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPUISpacingLabel.h"
#import "UIDevice+Platform.h"

@implementation OPUISpacingLabel


- (void)drawRect:(CGRect)rect {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
    [attributedString addAttribute:NSKernAttributeName
                             value:@([self constant])
                             range:NSMakeRange(0, self.text.length)];
    
    self.attributedText = attributedString;

    [super drawRect:rect];
 }

-(CGFloat)constant {
    
    if (UIScreen.mainScreen.nativeScale > 2) {
        return self.smallDevicesValue;
    }
    
    switch (UIDevice.currentDevice.deviceType) {
        case UIDeviceGroupLarge:
            return self.largeDevicesValue;
        case UIDeviceGroupSmall:
            return self.smallDevicesValue;
        case UIDeviceGroupMiddle:
            return self.middleDevicesValue;
            
        default:
            return 7.0;
    }
}

@end

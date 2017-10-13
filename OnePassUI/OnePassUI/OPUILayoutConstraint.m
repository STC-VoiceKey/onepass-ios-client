//
//  OPUILayoutConstraint.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 27.10.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPUILayoutConstraint.h"

#import "UIDevice+Platform.h"

@implementation OPUILayoutConstraint

-(CGFloat)constant {
    if (UIScreen.mainScreen.nativeScale > 2) {
        if (UIDevice.currentDevice.deviceType == UIDeviceGroupLarge) {
            return self.largeDevicesValue;
        } else
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
            break;
    }
    return super.constant;
}

@end

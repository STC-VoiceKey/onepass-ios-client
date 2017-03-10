//
//  UIDevice+Platform.h
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 01.11.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    UIDeviceGroupSmall, /// iPhone 1-5S, iPhoneSE, iPod
    UIDeviceGroupMiddle,/// iPhone 6, 6S, 7
    UIDeviceGroupLarge, /// iPad, iPhone 6 Plus, 6s Plus, 7 Plus
    UIDeviceGroupUnknown/// Unknown group
} UIDeviceGroup;/// Groups devices on the basis of their screen size

/**
 Category splits devices into three groups on the basis of their screen size
 */
@interface UIDevice (Platform)

/**
 Determines the device type
 
 @return The device type
 */
-(UIDeviceGroup)deviceType;

@end

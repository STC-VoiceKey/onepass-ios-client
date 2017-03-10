//
//  UIDevice+Platform.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 01.11.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "UIDevice+Platform.h"

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

@implementation UIDevice (Platform)

-(UIDeviceGroup)deviceType{
    NSString *result = [self getSysInfoByName:"hw.machine"];
    
    if([result  containsString:@"iPad"] ||
       [result  containsString:@"iPhone7,1"] ||
       [result  containsString:@"iPhone8,2"] ||
       [result  containsString:@"iPhone9,2"] ||
       [result  containsString:@"iPhone9,4"]) {
        return UIDeviceGroupLarge;
    }
    
    if([result  containsString:@"iPhone1,1"] ||
       [result  containsString:@"iPhone1,2"] ||
       [result  containsString:@"iPhone2,1"] ||
       [result  containsString:@"iPhone3,1"] ||
       [result  containsString:@"iPhone3,3"] ||
       [result  containsString:@"iPhone4,1"] ||
       [result  containsString:@"iPhone5,1"] ||
       [result  containsString:@"iPhone5,2"] ||
       [result  containsString:@"iPhone5,3"] ||
       [result  containsString:@"iPhone5,4"] ||
       [result  containsString:@"iPhone6,1"] ||
       [result  containsString:@"iPhone6,2"] ||
       [result  containsString:@"iPhone8,3"] ||
       [result  containsString:@"iPhone8,4"] ||
       [result  containsString:@"iPod"]) {
        return UIDeviceGroupSmall;
    }
    
    if ([result  containsString:@"iPhone7,2"] ||
        [result  containsString:@"iPhone8,1"] ||
        [result  containsString:@"iPhone9,1"] ||
        [result  containsString:@"iPhone9,3"]) {
        return UIDeviceGroupMiddle;
    }
    
    return UIDeviceGroupUnknown;
}

- (NSString *) getSysInfoByName:(char *)typeSpecifier{
    size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    
    char *answer = malloc(size);
    sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
    
    NSString *results = [NSString stringWithCString:answer encoding:NSUTF8StringEncoding];
    
    free(answer);
    return results;
}

@end

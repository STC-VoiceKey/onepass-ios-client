//
//  OPCDeviceUtil.m
//  OnePassCore
//
//  Created by Soloshcheva Aleksandra on 29.08.2018.
//  Copyright © 2018 Speech Technology Center. All rights reserved.
//

#import "OPCDeviceUtil.h"

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

@implementation OPCDeviceUtil

+ (NSString *) device {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    
    char *answer = malloc(size);
    sysctlbyname("hw.machine", answer, &size, NULL, 0);
    
    NSString *results = [NSString stringWithCString:answer encoding:NSUTF8StringEncoding];
    
    free(answer);
    return results;
}

@end

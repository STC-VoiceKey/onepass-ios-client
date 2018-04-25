//
//  OPUITransportService.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 23.11.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import "OPUITransportService.h"

@implementation OPUITransportService

-(id)initWithService:(id<IOPCTransportProtocol>)service {
    self = [super init];
    if (self) {
        self.service = service;
    }
    return self;
}

@end

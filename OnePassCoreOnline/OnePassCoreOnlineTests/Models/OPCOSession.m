//
//  OPCOSession.m
//  OnePassCoreOnlineTests
//
//  Created by Soloshcheva Aleksandra on 27.10.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import "OPCOSession.h"

@implementation OPCOSession

+(id<IOPCSession>)goodSessionData {
    id<IOPCSession> session = [[OPCOSession alloc] init];
    session.username = @"admin";
    session.password = @"QL0AFWMIX8NRZTKeof9cXsvbvu8=";
    session.domain   = @"201";
    return session;
}

+(id<IOPCSession>)badSessionData {
    id<IOPCSession> session = [[OPCOSession alloc] init];
    session.username = @"adminFail";
    session.password = @"QL0AFWMIX8NRZTKeof9cXsvbvu8=";
    session.domain   = @"201";
    return session;
}

@end

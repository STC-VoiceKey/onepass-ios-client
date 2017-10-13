//
//  OPCOVerificationSession.m
//  OnePassCoreOnline
//
//  Created by Soloshcheva Aleksandra on 24.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPCOVerificationSession.h"

@implementation OPCOVerificationSession

-(id)initWithJSON:(NSDictionary *)json{
    self = [super init];
    
    if (self) {
        if (json[@"verificationId"] && json[@"password"]) {
            self.verificationSessionID = json[@"verificationId"];
            self.passphrase = json[@"password"] ;
        } else {
            if (json[@"transactionId"] && json[@"password"]) {
                self.verificationSessionID = json[@"transactionId"];
                self.passphrase = json[@"password"] ;
            }
        }
    }
    
    return self;
}

@end

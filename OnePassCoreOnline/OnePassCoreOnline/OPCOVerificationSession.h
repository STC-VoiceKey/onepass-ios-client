//
//  OPCOVerificationSession.h
//  OnePassCoreOnline
//
//  Created by Soloshcheva Aleksandra on 24.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OnePassCore/OnePassCore.h>

@interface OPCOVerificationSession : NSObject<IVerifySession>

@property (nonatomic) NSString *verificationSessionID;
@property (nonatomic) NSString *passphrase;

-(id)initWithJSON:(NSDictionary *)json;

@end

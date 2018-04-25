//
//  OPCOSession.h
//  OnePassCoreOnlineTests
//
//  Created by Soloshcheva Aleksandra on 27.10.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OnePassCore/OnePassCore.h>

@interface OPCOSession : NSObject<IOPCSession>

@property(nonatomic) NSString *username;
@property(nonatomic) NSString *password;
@property(nonatomic) NSString *domain;

+(id<IOPCSession>)goodSessionData;
+(id<IOPCSession>)badSessionData;

@end

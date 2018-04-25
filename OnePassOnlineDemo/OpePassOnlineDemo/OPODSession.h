//
//  OPODSession.h
//  OnePassOnlineDemo
//
//  Created by Soloshcheva Aleksandra on 16.10.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OnePassCore/OnePassCore.h>

@interface OPODSession : NSObject<IOPCSession>

@property(nonatomic) NSString *username;
@property(nonatomic) NSString *password;
@property(nonatomic) NSString *domain;

@end

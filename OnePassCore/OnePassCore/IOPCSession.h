//
//  IOPCSession.h
//  OnePassCore
//
//  Created by Soloshcheva Aleksandra on 13.10.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IOPCSession <NSObject>

-(void)setUsername:(NSString *)username;
-(NSString *)username;

-(void)setPassword:(NSString *)password;
-(NSString *)password;

-(void)setDomain:(NSString *)domain;
-(NSString *)domain;

@end

//
//  OPODConfigManager.h
//  OnePassOnlineDemo
//
//  Created by Soloshcheva Aleksandra on 16.10.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OnePassCore/OnePassCore.h>

@protocol IOPODSettingsManagerProtocol

@required
-(NSString *)version;

-(NSString *)user;

-(NSString *)serverURL;
-(NSString *)defaultURL;
-(void)changeServerURL:(NSString *)url;

-(NSString *)sessionServerURL;
-(NSString *)defaultSessionServerURL;
-(void)changeSessionServerURL:(NSString *)url;

-(id<IOPCSession>)sessionData;
-(id<IOPCSession>)cryptedSessionData;
-(NSString *)crypte:(NSString *)password;
-(id<IOPCSession>)defaultSessionData;
-(void)changeSessionData:(id<IOPCSession>)sessionData;
-(BOOL)sessionDataHasEmptyFields:(id<IOPCSession>)sessionData;

-(NSDictionary *)modalities;
-(NSDictionary *)defaultModalities;
-(void)changeModalities:(NSDictionary *)modalities;

-(BOOL)isSmallResolution;
-(void)changeResolution:(BOOL)isSmall;

@end

@interface OPODSettingsManager : NSObject<IOPODSettingsManagerProtocol>


@end

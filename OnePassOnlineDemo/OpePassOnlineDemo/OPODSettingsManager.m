//
//  OPODConfigManager.m
//  OnePassOnlineDemo
//
//  Created by Soloshcheva Aleksandra on 16.10.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import "OPODSettingsManager.h"
#import "OPODSession.h"

#import <OnePassCore/OnePassCore.h>
#import <CommonCrypto/CommonDigest.h>

static NSString *kOnePassServerURL  = @"kOnePassRestURL_v31";
static NSString *kOnePassSession    = @"kOnePassSessionData_v31";
static NSString *kOnePassModalities = @"kOnePassModalities_v31";
static NSString *kOnePassResolution = @"kOnePassResolution_v31";
static NSString *kOnePassUserIDKey  = @"kOnePassUserIDKey_v31";

@interface OPODSettingsManager(Private)

-(NSString *)sha1:(NSString *)password;

@end

@implementation OPODSettingsManager

-(NSString *)version {
    NSString * version = [NSBundle.mainBundle objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    NSString * build   = [NSBundle.mainBundle objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey];
    NSString * descr   = [NSBundle.mainBundle objectForInfoDictionaryKey: @"STCVersionDescription"];
    
    return [NSString stringWithFormat:@"%@ (%@) - %@", version, build, descr];
}

-(NSString *)user {
   return [NSUserDefaults.standardUserDefaults stringForKey:kOnePassUserIDKey];
}

-(NSString *)serverURL {
   NSString *serverUrlFromDefaults = [NSUserDefaults.standardUserDefaults stringForKey:kOnePassServerURL];
    
    if (serverUrlFromDefaults && serverUrlFromDefaults.length>0) {
        return [NSString stringWithString:serverUrlFromDefaults];
    } else {
        return self.defaultURL;
    }
}

-(NSString *)defaultURL {
    return [NSBundle.mainBundle objectForInfoDictionaryKey:@"ServerUrl"];
}

-(void)changeServerURL:(NSString *)url {
    [self saveServerURL:url];
}

-(void)saveServerURL:(NSString *)url {
    [NSUserDefaults.standardUserDefaults setObject:url forKey:kOnePassServerURL];
    [NSUserDefaults.standardUserDefaults synchronize];
}

-(id<IOPCSession>)sessionData{
    NSDictionary *sessionDataDictionary = [NSUserDefaults.standardUserDefaults objectForKey:kOnePassSession];
    
    if (sessionDataDictionary != nil) {
        return [self sessionDataFrom:sessionDataDictionary];
    } else {
        return self.defaultSessionData;
    }
}

- (id<IOPCSession>)cryptedSessionData {
    id<IOPCSession> sessionData = [self sessionData];
    
    sessionData.password = [self sha1:sessionData.password];
    
    return sessionData;
}

-(NSString *)crypte:(NSString *)password{
    return [self sha1:password];
}

-(id<IOPCSession>)defaultSessionData {
    NSDictionary *sessionDictionary = [NSBundle.mainBundle objectForInfoDictionaryKey:@"SessionData"];
    return [self sessionDataFrom:sessionDictionary];
}

- (void)changeSessionData:(id<IOPCSession>)sessionData {
    [self saveSessionToUserDefaults:sessionData];
}

-(BOOL)sessionDataHasEmptyFields:(id<IOPCSession>)sessionData {
    
    if ( [sessionData.password isEqualToString:@""] ||
         [sessionData.username isEqualToString:@""] ||
         [sessionData.domain isEqualToString:@""] ) {
        return YES;
    }
    
    return NO;
}

-(id<IOPCSession>)sessionDataFrom:(NSDictionary *)dictionary {
    id<IOPCSession> sessionData = [[OPODSession alloc] init];
    
    sessionData.username = dictionary[@"username"];
    sessionData.password = dictionary[@"password"];
    sessionData.domain   = dictionary[@"domainId"];
    
    return sessionData;
}

-(void)saveSessionToUserDefaults:(id<IOPCSession>)sessionData {
    NSDictionary *sessionDataDictionary = @{ @"domainId":sessionData.domain,
                                             @"password":sessionData.password,
                                             @"username":sessionData.username };
    
    [NSUserDefaults.standardUserDefaults setObject:sessionDataDictionary forKey:kOnePassSession];
    [NSUserDefaults.standardUserDefaults synchronize];
}

-(NSDictionary *)modalities {
    NSDictionary *modalitiesDictionary = [NSUserDefaults.standardUserDefaults objectForKey:kOnePassModalities];
    
    if (modalitiesDictionary != nil) {
        return modalitiesDictionary;
    } else {
        return self.defaultModalities;
    }
}

-(NSDictionary *)defaultModalities {
    NSDictionary *modalities = [NSBundle.mainBundle objectForInfoDictionaryKey:@"Modalities"];
    return modalities;
}

-(void)changeModalities:(NSDictionary *)modalities{
    [NSUserDefaults.standardUserDefaults setObject:modalities forKey:kOnePassModalities];
    [NSUserDefaults.standardUserDefaults synchronize];
}

- (void)changeResolution:(BOOL)isSmall {
    [NSUserDefaults.standardUserDefaults setBool:isSmall forKey:kOnePassResolution];
    [NSUserDefaults.standardUserDefaults synchronize];
}


- (BOOL)isSmallResolution {
    if([NSUserDefaults.standardUserDefaults valueForKey:kOnePassResolution]) {
        return [NSUserDefaults.standardUserDefaults boolForKey:kOnePassResolution];
    }
    
    return self.defaultResolution;
}




-(BOOL)defaultResolution {
    BOOL resolution = [[NSBundle.mainBundle objectForInfoDictionaryKey:@"isSmallResolution"] boolValue];
    return resolution;
}

@end

@implementation OPODSettingsManager(Private)

-(NSString*)sha1:(NSString*)input {
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(NSInteger i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
        if (i!=(CC_SHA1_DIGEST_LENGTH - 1)){
            [output appendFormat:@"-"];
        }
    }
    
    NSMutableData *sha1Data = [self convertToByteData:output];
    
    NSString * result = [sha1Data base64EncodedStringWithOptions:0];
    
    return result;
}

-(NSMutableData *)convertToByteData:(NSString *)source {
    NSArray *tmp_arr = [source componentsSeparatedByString:@"-"];
    NSMutableData *commandToSend = [[NSMutableData alloc] init];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [tmp_arr count]; i++) {
        byte_chars[0] = [[tmp_arr objectAtIndex:i] characterAtIndex:0];
        byte_chars[1] = [[tmp_arr objectAtIndex:i] characterAtIndex:1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [commandToSend appendBytes:&whole_byte length:1];
    }
    return commandToSend;
}

@end

//
//  OPCOManager.m
//  OnePassCoreOnline
//
//  Created by Soloshcheva Aleksandra on 23.05.17.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import "OPCOManager.h"
#import "OPCOVerificationSession.h"
#import "NSURLResponse+IsSuccess.h"

#import "Reachability.h"

@interface OPCOManager()

/**
 * The session data: username, password, domain.
 */
@property (nonatomic,readonly) NSDictionary *session;

/**
 * The current session id.
 */
@property (nonatomic)              NSString *sessionId;

/**
 * The current transaction id.
 */
@property (nonatomic)              NSString *transactionId;

/**
 * Shows the security session started.
 */
@property (nonatomic,readwrite) BOOL isSessionStarted;

/**
 Is instance of the third party library Reachability(from apple)
 Used to check the reachability of a given host name.
 */
@property (nonatomic) Reachability *internetReachability;

/**
 Shows that the host is accessible
 */
@property (nonatomic) BOOL isHostAccessable;


@end

@interface OPCOManager(PrivateMethods)

/**
 Forms GET request
 
 @param urlString The URL for request
 @param body The body of the requests
 @param completionHandler The block which is called when data is received
 @return The request
 */
-(NSURLSessionDataTask *_Nonnull)taskGetRequestForURLString:(NSString *_Nonnull)urlString
                                                   withBody:(NSDictionary *__nullable)body
                                          completionHandler:(void (^_Nonnull)(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error))completionHandler;
/**
 Forms POST request
 
 @param urlString The URL for request
 @param body The body of the requests
 @param completionHandler The block which is called when data is received
 @return The request
 */
-(NSURLSessionDataTask *_Nullable)taskPostRequestForURLString:(NSString * _Nonnull)urlString
                                                     withBody:(NSDictionary * _Nullable)body
                                            completionHandler:(void (^_Nullable)(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error))completionHandler;
/**
 Forms DELETE request
 
 @param urlString The URL for request
 @param completionHandler The block which is called when data is received
 @return The request
 */
-(NSURLSessionDataTask *_Nonnull)taskDeleteRequestForURLString:(NSString * _Nonnull)urlString
                                             completionHandler:(void (^_Nullable)(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error))completionHandler;

/**
 Forms common request
 
 @param type The  request type(POST, GET, etc)
 @param urlString The URL for request
 @param body The body of the requests
 @param completionHandler The block which is called when data is received
 @return The request
 */
-(NSURLSessionDataTask *_Nonnull)taskRequestWithTypeRequest:(NSString * _Nonnull)type
                                                   withBody:(NSDictionary * _Nullable)body
                                               forURLString:(NSString * _Nonnull)urlString
                                          completionHandler:(void (^_Nullable)(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error))completionHandler;
/**
 Forms an error based on the responce data from the server
 
 @param errorData The responce data from the server
 @return The formed error
 */
-(NSError *_Nonnull)errorWithData:(NSData *_Nullable)errorData ;

@end


@implementation OPCOManager

-(id)init{
    self = [super init];
    
    if(self){
        
        _session = [NSBundle.mainBundle objectForInfoDictionaryKey:@"SessionData"];
        _isSessionStarted = NO;
        
        NSString *serverUrlFromDefaults = [NSUserDefaults.standardUserDefaults stringForKey:kOnePassServerURL];
        
        if (serverUrlFromDefaults && serverUrlFromDefaults.length>0) {
            _serverUrl = [NSString stringWithString:serverUrlFromDefaults];
        }
        else{
            _serverUrl = [NSBundle.mainBundle objectForInfoDictionaryKey:@"ServerUrl"];
#warning Сделать асерт
            
            //            NSAssert( _serverUrl==nil, @"Set Server URL .plist");
            [NSUserDefaults.standardUserDefaults setObject:_serverUrl forKey:kOnePassServerURL];
            [NSUserDefaults.standardUserDefaults synchronize];
        }
        
        NSLog(@"server url - %@",_serverUrl);
        
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(reachabilityChanged:)
                                                   name:kReachabilityChangedNotification
                                                 object:nil];
        
        self.internetReachability = [Reachability reachabilityForInternetConnection];
        [self.internetReachability startNotifier];
        [self updateInterfaceWithReachability:self.internetReachability];
    }
    
    return self;
}

- (void)updateInterfaceWithReachability:(Reachability *)reachability {
    
    if (reachability == self.internetReachability) {
        NetworkStatus netStatus = [reachability currentReachabilityStatus];
        NSLog(@"internet netStatus = %ld",(long)netStatus);
        
        self.isHostAccessable = (netStatus!=NotReachable);
    }
}

/**
 * Called by Reachability whenever status changes.
 */
- (void) reachabilityChanged:(NSNotification *)note {
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}

-(void)createSessionWithCompletionBlock:(ResponceBlock)block {
    ResponceBlock resultBlock = block;
    
    NSDictionary *body = @{kUsernameURLParam:self.session[@"username"],
                           kPasswordURLParam:self.session[@"password"],
                           kDomainIdURLParam:self.session[@"domainId"]};
    
    NSURLSessionDataTask *task = [self taskPostRequestForURLString:[NSString stringWithFormat:kCreateSession, self.serverUrl]
                                                          withBody:body
                                                 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error){
                                                     NSLog(@"create session -  %@",response);
                                                     
                                                     if (!error) {
                                                         if ([response isSuccess]) {
                                                             NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                             _sessionId = json[@"sessionId"];
                                                             self.isSessionStarted = YES;
                                                             if(resultBlock) {
                                                                 resultBlock(nil,nil);
                                                             }
                                                         } else {
                                                             if ([response is404] || [response is500]) {
                                                                 if(resultBlock) {
                                                                     resultBlock(nil,[NSError errorWithDomain:@"com.speachpro.onepass"
                                                                                                         code:404
                                                                                                     userInfo:@{  NSLocalizedDescriptionKey:@"Incorrect URL. Please, enter the correct one." }]);
                                                                 }
                                                             }
                                                         }
                                                     } else {
                                                         if(resultBlock) {
                                                             resultBlock(nil,[NSError errorWithDomain:@"com.speachpro.onepass"
                                                                                                 code:404
                                                                                             userInfo:@{ NSLocalizedDescriptionKey: @"Incorrect URL. Please, enter the correct one." }]);
                                                         }
                                                     }
                                                     

                                                 }];
    
    [task resume];
}

-(void)deleteSessionWithCompletionBlock:(ResponceBlock)block {
    if(block){
        block(nil,nil);
    }
}

-(void)createPerson:(NSString *)personId withCompletionBlock:(ResponceBlock) block {
    ResponceBlock resultBlock = block;
    self.transactionId = nil;
    NSURLSessionDataTask *task = [self taskGetRequestForURLString:[NSString stringWithFormat:kStartRegistration,self.serverUrl,personId ]
                                                          withBody:nil
                                                 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error){
                                                     NSLog(@"create person -  %@",response);
                                                     if(!error){
                                                         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                         self.transactionId = json[@"transactionId"];
                                                     }
                                                     if(resultBlock) {
                                                         resultBlock(nil,[response isSuccess] ? nil : [self errorWithData:data]);
                                                     }
                                                 }];
    
    [task resume];
}

-(void)addFaceSample:(NSData *)imageData forPerson:(NSString *)personId withCompletionBlock:(ResponceBlock)block {
    ResponceBlock resultBlock = block;
    NSURLSessionDataTask *task = [self taskPostRequestForURLString:[NSString stringWithFormat:kAddRegistrationFaceFile,self.serverUrl]
                                                          withBody:@{kDataURLParam:[imageData base64EncodedStringWithOptions:0]}
                                                 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error){
                                                     if (!error){
                                                         NSLog(@"add face sample - %@",response);
                                                         if(resultBlock) resultBlock(nil,[response isSuccess] ? nil : [self errorWithData:data]);
                                                     }else{
                                                         resultBlock(nil,error);
                                                         return ;
                                                     }
                                                     
                                                 }];
    [task resume];
}

-(void)addVoiceFile:(NSData *)voiceData withPassphrase:(NSString *)passphrase forPerson:(NSString *)personId withCompletionBlock:(ResponceBlock)block {
    ResponceBlock resultBlock = block;
    
    NSURLSessionDataTask *task = [self taskPostRequestForURLString:[NSString stringWithFormat:kAddRegistrationVoiceFile,self.serverUrl]
                                                          withBody:@{ kDataURLParam:[voiceData base64EncodedStringWithOptions:0],
                                                                      kPasswordURLParam:passphrase,
                                                                      kGenderURLParam:@0,
                                                                      kChannelURLParam:@0 }
                                                 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error){
                                                     
                                                     NSLog(@"%@", response);
                                                     if (!error){
                                                         if(resultBlock) resultBlock(nil,[response isSuccess] ? nil : [self errorWithData:data]);
                                                     } else {
                                                         resultBlock(nil,error);
                                                         return ;
                                                     }
                                                 }];
    [task resume];
}

-(void)startVerificationSession:(NSString *)personId withCompletionBlock:(ResponceVerifyBlock)block {
    ResponceVerifyBlock resultBlock = block;
    
    self.transactionId = nil;
    NSURLSessionDataTask *task = [self taskGetRequestForURLString:[NSString stringWithFormat:kStartVerification,self.serverUrl,personId]
                                                         withBody:nil
                                                completionHandler:^(NSData * _Nullable data,
                                                                    NSURLResponse * _Nullable response,
                                                                    NSError * _Nullable error){
                                                    if (!error) {
                                                        
                                                        NSLog(@"start session %@",response);
                                                        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

                                                        if ([response isSuccess]) {
                                                            OPCOVerificationSession *vSession = [[OPCOVerificationSession alloc] initWithJSON:json];
                                                            self.transactionId = json[@"transactionId"];
                                                            if(resultBlock) {
                                                                resultBlock(vSession,nil);
                                                            }
                                                        } else
                                                            if(resultBlock) resultBlock(nil,[self errorWithData:data]);
                                                        
                                                    } else {
                                                        resultBlock(nil,error);
                                                        return ;
                                                    }
                                                }];
    
    [task resume];
}

-(void)addVerificationVideo:(NSData *)video
                 forSession:(NSString *)session
               withPasscode:(NSString *)passcode
        withCompletionBlock:(ResponceBlock)block {
    ResponceBlock resultBlock = block;
    
    NSURLSessionDataTask *task = [self taskPostRequestForURLString:[NSString stringWithFormat:kVerificationVideo, self.serverUrl, session]
                                                          withBody:@{kDataURLParam:[video base64EncodedStringWithOptions:0],kPasswordURLParam:passcode}
                                                 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error){
                                                     if (!error){
                                                         NSLog(@"add video sample %@",response);
                                                         if(resultBlock) {
                                                             resultBlock(nil,[response isSuccess] ? nil : [self errorWithData:data]);
                                                         }
                                                     } else {
                                                         resultBlock(nil,error);
                                                         return ;
                                                     }
                                                 }];
    [task resume];
}

-(void)addVerificationFace:(NSData *)face
                forSession:(NSString *)session
       withCompletionBlock:(ResponceBlock)block {
    ResponceBlock resultBlock = block;
    
    NSURLSessionDataTask *task = [self taskPostRequestForURLString:[NSString stringWithFormat:kVerificationFace, self.serverUrl, session]
                                                          withBody:@{kDataURLParam:[face base64EncodedStringWithOptions:0]}
                                                 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error){
                                                     if (!error){
                                                         NSLog(@"add face sample %@",response);
                                                         if(resultBlock) {
                                                             resultBlock(nil,[response isSuccess] ? nil : [self errorWithData:data]);
                                                         }
                                                     } else {
                                                         resultBlock(nil,error);
                                                         return ;
                                                     }
                                                 }];
    [task resume];
}

-(void)verify:(NSString *)session withCompletionBlock:(ResponceBlock)block {
    ResponceBlock resultBlock = block;
    NSURLSessionDataTask *task = [self taskGetRequestForURLString:[NSString stringWithFormat:KverificationResult,self.serverUrl]
                                                         withBody:nil
                                                completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                  {
                                      if (!error) {
                                          NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                          NSLog(@"verify - \n%@",json);
                                          
                                          if(resultBlock) resultBlock(json,[response isSuccess] ? nil : [self errorWithData:data]);
                                      } else {
                                          resultBlock(nil,error);
                                          return ;
                                      }
                                  }];
    
    [task resume];
}

-(void)verifyScore:(NSString *)session withCompletionBlock:(ResponceBlock)block {
    ResponceBlock resultBlock = block;
    NSURLSessionDataTask *task = [self taskGetRequestForURLString:[NSString stringWithFormat:KverificationResultScore, self.serverUrl, session]
                                                         withBody:nil
                                                completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                    if (!error) {
                                                        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                        NSLog(@"verify - !!!!! SCORE !!!!! \n%@",json);
                                                        
                                                        if(resultBlock) resultBlock(json,[response isSuccess] ? nil : [self errorWithData:data]);
                                                    } else {
                                                        resultBlock(nil,error);
                                                        return ;
                                                    }
                                                }];
    
    [task resume];
}

-(void)closeVerification:(NSString *)session withCompletionBlock:(ResponceBlock)block {
    ResponceBlock resultBlock = block;
    NSURLSessionDataTask *task = [self taskDeleteRequestForURLString:[NSString stringWithFormat:kVerification,self.serverUrl,session]
                                                   completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                       if (!error) {
                                                           NSLog(@"close session %@",response);
                                                           if(resultBlock) {
                                                               resultBlock( nil, [response isSuccess] ? nil : [self errorWithData:data]);
                                                           }
                                                       } else {
                                                           if(resultBlock) resultBlock(nil,error);
                                                           return ;
                                                       }
                                                   }];
    
    [task resume];
}


-(void)addVerificationData:(NSData *)imageData
         withVoiceFeatures:(NSData *)voiceFeatures
            withLdFeatures:(NSData *)ldFeatures
                forSession:(NSString *)session
              withPasscode:(NSString *)passcode
       withCompletionBlock:(ResponceBlock)block{
    ResponceBlock resultBlock = block;
    if ((imageData==nil) || (voiceFeatures==nil) || (ldFeatures==nil)) {
        resultBlock(nil,[NSError errorWithDomain:@"com.speachpro.onepass"
                                            code:400
                                        userInfo:@{ NSLocalizedDescriptionKey: @"No valid data for verification" }]);
        return;
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *loggingFolder =  [paths objectAtIndex:0];
    
    NSString *ldFeaturesPath =  [loggingFolder stringByAppendingPathComponent:[NSString stringWithFormat:@"ldFeatures.bin"]];
    [ldFeatures writeToFile:ldFeaturesPath atomically:YES];
    NSString *voiceFeaturesPath =  [loggingFolder stringByAppendingPathComponent:[NSString stringWithFormat:@"voiceFeatures.bin"]];
    [voiceFeatures writeToFile:voiceFeaturesPath atomically:YES];
    
    NSDictionary *body = @{kFeaturesURLParam:@{kDataURLParam:[voiceFeatures base64EncodedStringWithOptions:0]},
                           kFaceURLParam:@{kSampleURLParam:@{kDataURLParam:[imageData base64EncodedStringWithOptions:0]}},
                           kLDFeaturesURLParam:@{kDataURLParam:[ldFeatures base64EncodedStringWithOptions:0]},
                           kPasswordURLParam:passcode};
    
    NSURLSessionDataTask *task = [self taskPostRequestForURLString:[NSString stringWithFormat:kAddData2VerificationSession,_serverUrl,session]
                                                          withBody:body
                                                 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                     if (!error){
                                                         NSLog(@"add data sample %@",response);
                                                         if(resultBlock) resultBlock(nil,[response isSuccess] ? nil : [self errorWithData:data]);
                                                     } else {
                                                         resultBlock(nil,error);
                                                         return ;
                                                     }
                                                 }];
    [task resume];
}


-(void)changeServerURL:(NSString *)url {
    _serverUrl = url;
//    [NSUserDefaults.standardUserDefaults setObject:_serverUrl forKey:kOnePassServerURL];
//    [NSUserDefaults.standardUserDefaults synchronize];
}

-(void)deletePerson:(NSString *)personId withCompletionBlock:(ResponceBlock) block{
    ResponceBlock resultBlock = block;
    
    NSURLSessionDataTask *task = [self taskDeleteRequestForURLString:[NSString stringWithFormat:kDeletePersonById,_serverUrl,personId]
                                                   completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error){
                                                       if (!error){
                                                           NSLog(@"delete person -  %@",response);
                                                           if(resultBlock) resultBlock(nil,[response isSuccess] ? nil : [self errorWithData:data]);
                                                       }else{
                                                           resultBlock(nil,error);
                                                           return ;
                                                       }
                                                   }];
    
    [task resume];
}

-(void)readPerson:(NSString *)personId withCompletionBlock:(ResponceBlock)block{
    ResponceBlock resultBlock = block;

    __unused NSURLSessionDataTask *task = [self taskGetRequestForURLString:[NSString stringWithFormat:kReadPersonById, _serverUrl, personId]
                                                                  withBody:nil
                                                         completionHandler:^(NSData * _Nullable data,
                                                                             NSURLResponse * _Nullable response,
                                                                             NSError * _Nullable error){
                                                             NSLog(@"read person %@",response);
                                                             NSLog(@"%@",error);
                                                             if(!error){
                                                                 NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                 if(resultBlock){
                                                                     if([response isSuccess]) resultBlock(json,nil);
                                                                     else                     resultBlock(nil,[self errorWithData:data]);
                                                                 }
                                                             }else{
                                                                 resultBlock(nil,error);
                                                                 return ;
                                                             }

                                                         }];

    [task resume];
}
@end

//-----------------------
/// Private Methods
///-----------------------
@implementation OPCOManager(PrivateMethods)

-(NSURLSessionDataTask *)taskGetRequestForURLString:(NSString *)urlString
                                           withBody:(NSDictionary *)body
                                  completionHandler:(void (^)(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error))completionHandler {
    
    return [self taskRequestWithTypeRequest:@"GET"
                                   withBody:body
                               forURLString:urlString
                          completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                              if (completionHandler) {
                                  completionHandler(data,response,error);
                              }
                          }];
    
}

-(NSURLSessionDataTask *)taskPostRequestForURLString:(NSString *)urlString
                                            withBody:(NSDictionary *)body
                                   completionHandler:(void (^)(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error))completionHandler {
    
    return [self taskRequestWithTypeRequest:@"POST"
                                   withBody:body
                               forURLString:urlString
                          completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                              if (completionHandler) {
                                  completionHandler(data,response,error);
                              }
                          }];
    
}

-(NSURLSessionDataTask *)taskDeleteRequestForURLString:(NSString *)urlString
                                     completionHandler:(void (^)(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error))completionHandler {
    return [self taskRequestWithTypeRequest:@"DELETE"
                                   withBody:nil
                               forURLString:urlString
                          completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                              if (completionHandler) {
                                  completionHandler(data,response,error);
                              }
                          }];
}


-(NSURLSessionDataTask *)taskRequestWithTypeRequest:(NSString *)type
                                           withBody:(NSDictionary *)body
                                       forURLString:(NSString *)urlString
                                  completionHandler:(void (^)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable))completionHandler {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL URLWithString:urlString]
                                    cachePolicy: NSURLRequestReloadIgnoringCacheData
                                    timeoutInterval: 20];
    
    [request setHTTPMethod:type];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    if(body) {
        NSString *bodyJSON = [body JSONString];
        [request setHTTPBody:[bodyJSON dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if (self.sessionId) {
        [request addValue:self.sessionId forHTTPHeaderField:@"X-Session-Id"];
    }
    
    if (self.transactionId) {
        [request addValue:self.transactionId forHTTPHeaderField:@"X-Transaction-Id"];
    }
    
    return [NSURLSession.sharedSession dataTaskWithRequest:request
                                         completionHandler:^(NSData * _Nullable data,
                                                             NSURLResponse * _Nullable response,
                                                             NSError * _Nullable error) {
                                             if (completionHandler) {
                                                 completionHandler(data,response,error);
                                             }
                                         }];
}

-(NSError *)errorWithData:(NSData *)errorData{
    NSString *errorString;
    
    NSError *error ;
    NSDictionary *errorDictionary = [NSJSONSerialization JSONObjectWithData:errorData options:0 error:&error];
    if(error){
        errorString = [[NSString alloc] initWithData:errorData encoding: NSUTF8StringEncoding];
    } else {
        errorString = errorDictionary[@"message"];
    }
    
    NSLog(@"%@",errorString);
    
    return [NSError errorWithDomain:@"com.speachpro.onepass"
                               code:400
                           userInfo:@{ NSLocalizedDescriptionKey: errorString }];    
}

-(NSString *)userID{
    return [NSUserDefaults.standardUserDefaults objectForKey:kOnePassUserIDKey];
}

@end


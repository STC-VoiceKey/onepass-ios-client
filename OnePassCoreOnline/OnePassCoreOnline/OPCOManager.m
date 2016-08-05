//
//  OPCOManager.m
//  OnePassCoreOnline
//
//  Created by Soloshcheva Aleksandra on 15.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPCOManager.h"
#import "OPCOPerson.h"
#import "OPCOVerificationSession.h"
#import "NSObject+JSON.h"
#import "NSURLResponse+IsSuccess.h"
#import "Reachability.h"

@interface OPCOManager()

@property (nonatomic,readonly) NSString *serverUrl;

@property (nonatomic) Reachability *internetReachability;

@end

static NSString *kOnePassServerURL = @"kOnePassServerURL";

static NSString *kOnePassUserIDKey    = @"kOnePassOnlineDemoKeyChainKey";
static NSString *personService        = @"person";
static NSString *personIDServiceParam = @"personId";

static NSString *sampleServiceParam   = @"sample";
static NSString *dataServiceParam     = @"data";
static NSString *passwordServiceParam = @"password";
static NSString *rateServiceParam     = @"samplingRate";
static NSString *genderServiceParam   = @"gender";


static NSString *faceService              = @"face/sample";
static NSString *voiceService             = @"voice/dynamic/sample";
static NSString *voiceFile                = @"voice/dynamic/file";
static NSString *verificationService      = @"verification";
static NSString *videoVerificationService = @"video/dynamic";
static NSString *startVerificationService = @"verification/start";


@interface OPCOManager(PrivateMethods)

-(NSURLSessionDataTask *)taskGetRequestForURLString:(NSString *)urlString
                                           withBody:(NSDictionary *)body
                                  completionHandler:(void (^)(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error))completionHandler;

-(NSURLSessionDataTask *)taskPostRequestForURLString:(NSString *)urlString
                                            withBody:(NSDictionary *)body
                                   completionHandler:(void (^)(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error))completionHandler;

-(NSURLSessionDataTask *)taskDeleteRequestForURLString:(NSString *)urlString
                                     completionHandler:(void (^)(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error))completionHandler;

-(NSError *)errorWithData:(NSData *)errorData ;

@end

@implementation OPCOManager

-(id)init{
    
    self = [super init];
    
    if(self){
        NSString *serverUrlFromDefaults = [[NSUserDefaults standardUserDefaults] stringForKey:kOnePassServerURL];
        if (serverUrlFromDefaults && serverUrlFromDefaults.length>0) {
            _serverUrl = [NSString stringWithString:serverUrlFromDefaults];
        }
        else
        {
            _serverUrl = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"ServerUrl"];
            [[NSUserDefaults standardUserDefaults] setObject:_serverUrl forKey:kOnePassServerURL];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        NSLog(@"server url - %@",_serverUrl);
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];

        self.internetReachability = [Reachability reachabilityForInternetConnection];
        [self.internetReachability startNotifier];
        [self updateInterfaceWithReachability:self.internetReachability];
    }
    
    return self;
}

-(BOOL)isHostAccessable
{
    Reachability *hostReachability = [Reachability reachabilityWithHostName:_serverUrl];
    
    NetworkStatus netStatus = [hostReachability currentReachabilityStatus];
    
    return (netStatus!=NotReachable);
}

-(BOOL)isInternetAccessable
{
    NetworkStatus netStatus = [self.internetReachability currentReachabilityStatus];
    
    return (netStatus!=NotReachable);
}

/*!
 * Called by Reachability whenever status changes.
 */
- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
    if (reachability == self.internetReachability)
    {
        NetworkStatus netStatus = [reachability currentReachabilityStatus];
        NSLog(@"internet netStatus = %ld",(long)netStatus);
    }
    
}

-(void)createPerson:(NSString *)personId withCompletionBlock:(ResponceBlock) block{
    ResponceBlock resultBlock = block;
    
    NSURLSessionDataTask *task = [self taskPostRequestForURLString:[NSString stringWithFormat:@"%@/%@",_serverUrl,personService]
                                                           withBody:@{personIDServiceParam:personId}
                                                  completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
        NSLog(@"create person -  %@",personId);
        if(resultBlock) resultBlock(nil,[response isSuccess] ? nil : [self errorWithData:data]);
    }];
    
    [task resume];
}

-(void)readPerson:(NSString *)personId withCompletionBlock:(ResponceBlock)block{
    ResponceBlock resultBlock = block;
    
    __unused NSURLSessionDataTask *task = [self taskGetRequestForURLString:[NSString stringWithFormat:@"%@/%@/%@",_serverUrl,personService,personId]
                                                                  withBody:nil

                                                         completionHandler:^(NSData * _Nullable data,
                                                                             NSURLResponse * _Nullable response,
                                                                             NSError * _Nullable error)
    {
        NSLog(@"read person");//%@",response);
        if(!error)
        {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
           // NSLog(@"%@",json);
            if(resultBlock)
            {
                if([response isSuccess]) resultBlock(json,nil);
                else                     resultBlock(nil,[self errorWithData:data]);
            }
        }else
        {
            resultBlock(nil,error);
            return ;
        }

    }];
    
    [task resume];
}


-(void)deletePerson:(NSString *)personId withCompletionBlock:(ResponceBlock) block
{
    ResponceBlock resultBlock = block;
    
    NSURLSessionDataTask *task = [self taskDeleteRequestForURLString:[NSString stringWithFormat:@"%@/%@/%@",_serverUrl,personService,personId]
                                                   completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
        if (!error)
        {
            NSLog(@"delete person -  %@",personId);
            if(resultBlock) resultBlock(nil,[response isSuccess] ? nil : [self errorWithData:data]);
        }else
        {
            resultBlock(nil,error);
            return ;
        }
    }];
    
    [task resume];
}

#pragma mark - Face Sample Upload

-(void)addFaceSample:(NSData *)imageData forPerson:(NSString *)personId withCompletionBlock:(ResponceBlock)block{
    ResponceBlock resultBlock = block;
    NSLog(@"lenght = %lu",(unsigned long)imageData.length);
    NSURLSessionDataTask *task = [self taskPostRequestForURLString:[NSString stringWithFormat:@"%@/%@/%@/%@",_serverUrl,personService,personId,faceService]
                                                           withBody:@{sampleServiceParam:@{dataServiceParam:[imageData base64EncodedStringWithOptions:0]}}
                                                  completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
        if (!error)
        {
            NSLog(@"add face sample - %@",response);
            if(resultBlock) resultBlock(nil,[response isSuccess] ? nil : [self errorWithData:data]);
        }else
        {
            resultBlock(nil,error);
            return ;
        }

    }];

    [task resume];

}

//-(void)addVoiceSample:(NSData *)voiceData withPassphrase:(NSString *)passphrase forPerson:(NSString *)personId withCompletionBlock:(ResponceBlock)block{
//    ResponceBlock resultBlock = block;
//    
//    NSURLSessionDataTask *task = [self taskPostRequestForURLString:[NSString stringWithFormat:@"%@/%@/%@/%@",_serverUrl,personService,personId,voiceService]
//                                                          withBody:@{  dataServiceParam:[voiceData base64Encoding],
//                                                                       passwordServiceParam:passphrase,
//                                                                       rateServiceParam:@11025,
//                                                                       genderServiceParam:@1}
//                                                 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
//    {
//        NSLog(@"add voice sample - %@",[response debugDescription]);
//        if(resultBlock) resultBlock(nil,[response isSuccess] ? nil : [self errorWithData:data]);
//
//    }];
//    
//    [task resume];
//}

-(void)addVoiceFile:(NSData *)voiceData withPassphrase:(NSString *)passphrase forPerson:(NSString *)personId withCompletionBlock:(ResponceBlock)block{
    //POST /person/{person_id}/voice/dynamic/file
    ResponceBlock resultBlock = block;
    
    NSURLSessionDataTask *task = [self taskPostRequestForURLString:[NSString stringWithFormat:@"%@/%@/%@/%@",_serverUrl,personService,personId,voiceFile]
                                                          withBody:@{  dataServiceParam:[voiceData base64EncodedStringWithOptions:0],
                                                                   passwordServiceParam:passphrase,
                                                                     genderServiceParam:@0}
                                                 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                  {

                                      if (!error)
                                      {
                                          NSLog(@"add voice file %@ - '%@'",passphrase,[response debugDescription]);
                                          if(resultBlock) resultBlock(nil,[response isSuccess] ? nil : [self errorWithData:data]);
                                      }else
                                      {
                                          resultBlock(nil,error);
                                          return ;
                                      }
                                  }];
    
    [task resume];
}

#pragma mark - VERIFICATION

-(void)startVerificationSession:(NSString *)personId withCompletionBlock:(ResponceVerifyBlock)block
{
    ResponceVerifyBlock resultBlock = block;
    
     NSURLSessionDataTask *task = [self taskGetRequestForURLString:[NSString stringWithFormat:@"%@/%@/%@",_serverUrl,startVerificationService,personId]
                                                          withBody:nil
                                                         completionHandler:^(NSData * _Nullable data,
                                                                             NSURLResponse * _Nullable response,
                                                                             NSError * _Nullable error)
    {
        if (!error)
        {
            NSLog(@"start session");
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if ([response isSuccess])
            {
                OPCOVerificationSession *session = [[OPCOVerificationSession alloc] initWithJSON:json];
                NSLog(@"verification - %@",json );
                if(resultBlock) resultBlock(session,nil);
            }else
                if(resultBlock) resultBlock(nil,[self errorWithData:data]);
        }else
        {
            resultBlock(nil,error);
            return ;
        }
    }];
 
    [task resume];
}

-(void)addVerificationVideo:(NSData *)video
                 forSession:(NSString *)session
               withPasscode:(NSString *)passcode
        withCompletionBlock:(ResponceBlock)block
{
    ResponceBlock resultBlock = block;
    
    NSURLSessionDataTask *task = [self taskPostRequestForURLString:[NSString stringWithFormat:@"%@/%@/%@/%@",_serverUrl,verificationService,session,videoVerificationService]
                                                          withBody:@{dataServiceParam:[video base64EncodedStringWithOptions:0],passwordServiceParam:passcode}
                                                 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
        if (!error)
        {
            NSLog(@"add video sample");
            if(resultBlock) resultBlock(nil,[response isSuccess] ? nil : [self errorWithData:data]);
        }else
        {
            resultBlock(nil,error);
            return ;
        }
    }];
    
    [task resume];
}

-(void)addVerificationFaceSample:(NSData *)imageData
                      forSession:(NSString *)session
             withCompletionBlock:(ResponceBlock)block{
    
    ResponceBlock resultBlock = block;
    
    NSURLSessionDataTask *task = [self taskPostRequestForURLString:[NSString stringWithFormat:@"%@/%@/%@/%@",_serverUrl,verificationService,session,faceService]
                                                          withBody:@{sampleServiceParam:@{dataServiceParam:[imageData base64EncodedStringWithOptions:0]}}
                                                 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                  {
                                      if (!error)
                                      {
                                          NSLog(@"add verification face sample - %@",response);
                                          if(resultBlock) resultBlock(nil,[response isSuccess] ? nil : [self errorWithData:data]);
                                      }else
                                      {
                                          resultBlock(nil,error);
                                          return ;
                                      }
                                      
                                  }];
    
    [task resume];
}


-(void)verify:(NSString *)session withCompletionBlock:(ResponceBlock)block{
    //GET /verification/{verification_id}
    ResponceBlock resultBlock = block;
    NSURLSessionDataTask *task = [self taskGetRequestForURLString:[NSString stringWithFormat:@"%@/%@/%@",_serverUrl,verificationService,session]
                                                          withBody:nil
                                                 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
        if (!error)
        {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"verify - \n%@",json);
            
            if(resultBlock) resultBlock(json,[response isSuccess] ? nil : [self errorWithData:data]);
        }
        else
        {
            resultBlock(nil,error);
            return ;
        }
    }];
    
    [task resume];
}

-(void)verifyScore:(NSString *)session withCompletionBlock:(ResponceBlock)block{
    //GET /verification/{verification_id}
    ResponceBlock resultBlock = block;
    NSURLSessionDataTask *task = [self taskGetRequestForURLString:[NSString stringWithFormat:@"%@/%@/%@/score",_serverUrl,verificationService,session]
                                                         withBody:nil
                                                completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                  {
                                      if (!error)
                                      {
                                          NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                          NSLog(@"verify - !!!!! SCORE !!!!! \n%@",json);
                                          
                                          if(resultBlock) resultBlock(json,[response isSuccess] ? nil : [self errorWithData:data]);
                                      }
                                      else
                                      {
                                          resultBlock(nil,error);
                                          return ;
                                      }
                                  }];
    
    [task resume];
}

-(void)closeVerification:(NSString *)session withCompletionBlock:(ResponceBlock)block{
    //DELETE /verification/{verification_id}
    ResponceBlock resultBlock = block;
    
    NSURLSessionDataTask *task = [self taskDeleteRequestForURLString:[NSString stringWithFormat:@"%@/%@/%@",_serverUrl,verificationService,session]
                                                completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
        NSLog(@"close session ");
        if (!error)
        {
            if(resultBlock) resultBlock(nil,[response isSuccess] ? nil : [self errorWithData:data]);
        }else
        {
            resultBlock(nil,error);
            return ;
        }
    }];
    
    [task resume];
}

@end

@implementation OPCOManager(PrivateMethods)

-(NSURLSessionDataTask *)taskGetRequestForURLString:(NSString *)urlString
                                           withBody:(NSDictionary *)body
                                  completionHandler:(void (^)(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error))completionHandler{

    return [self taskRequestWithTypeRequest:@"GET"
                                   withBody:body
                               forURLString:urlString
                          completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
        if (completionHandler) {
            completionHandler(data,response,error);
        }
    }];

}

-(NSURLSessionDataTask *)taskPostRequestForURLString:(NSString *)urlString
                                            withBody:(NSDictionary *)body
                                   completionHandler:(void (^)(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error))completionHandler{
    return [self taskRequestWithTypeRequest:@"POST"
                                   withBody:body
                               forURLString:urlString
                          completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
            {
                if (completionHandler) {
                    completionHandler(data,response,error);
                }
            }];
    
}

-(NSURLSessionDataTask *)taskDeleteRequestForURLString:(NSString *)urlString
                                     completionHandler:(void (^)(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error))completionHandler{
    return [self taskRequestWithTypeRequest:@"DELETE"
                                   withBody:nil
                               forURLString:urlString
                          completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
            {
                if (completionHandler) {
                    completionHandler(data,response,error);
                }
            }];
}


-(NSURLSessionDataTask *)taskRequestWithTypeRequest:(NSString *)type
                                           withBody:(NSDictionary *)body
                                       forURLString:(NSString *)urlString
                                  completionHandler:(void (^)(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error))completionHandler{
    
    
//    NetworkStatus netStatus = [self.internetReachability currentReachabilityStatus];
//    if (netStatus==NotReachable) {
//        if (completionHandler) {
//            completionHandler(nil,nil,[NSError errorWithDomain:@"com.speachpro.onepass"
//                                                          code:400
//                                                      userInfo:@{ NSLocalizedDescriptionKey: @"" }]);
//        }
//        return nil;
//    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL URLWithString:urlString]
                                    cachePolicy: NSURLRequestReloadIgnoringCacheData
                                    timeoutInterval: 20];
    
    [request setHTTPMethod:type];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    if(body){
        NSString* bodyJSON = [body sp_JSONString];
        [request setHTTPBody:[bodyJSON dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    return [[NSURLSession sharedSession] dataTaskWithRequest:request
                    completionHandler:^(NSData * _Nullable data,
                                        NSURLResponse * _Nullable response,
                                        NSError * _Nullable error)
    {
        if (completionHandler) {
            completionHandler(data,response,error);
        }
    }];
    
}

-(NSError *)errorWithData:(NSData *)errorData{
    NSString *errorString = [[NSString alloc] initWithData:errorData encoding: NSUTF8StringEncoding];
    NSLog(@"%@",errorString);
    
    return [NSError errorWithDomain:@"com.speachpro.onepass"
                               code:400
                           userInfo:@{ NSLocalizedDescriptionKey: errorString }];
    
}

@end

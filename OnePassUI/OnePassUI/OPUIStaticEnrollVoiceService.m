//
//  OPUIStaticEnrollVoiceService.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 01.08.2018.
//  Copyright © 2018 Speech Technology Center. All rights reserved.
//

#import "OPUIStaticEnrollVoiceService.h"
#import <OnePassCore/OnePassCore.h>

@interface OPUIStaticEnrollVoiceService()

@property (nonatomic) id<IOPCTransportProtocol> service;

@end

@implementation OPUIStaticEnrollVoiceService

-(void)setService:(id<IOPCTransportProtocol>)service{
    _service = service;
}

- (void)processVoice:(NSData *)data withPassphrase:(NSString *)passphrase withHandler:(OPUIResultBlock)handler { 
  //  <#code#>
}


-(void)processVoice:(NSData *)data
        withHandler:(OPUIResultBlock)handler {
    [self.service addStaticVoiceFile:data
           withCompletionBlock:^(NSDictionary *responceObject, NSError *error) {
               handler(responceObject,error);
           }];
}

@end

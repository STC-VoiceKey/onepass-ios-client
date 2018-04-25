//
//  OPUIEnrollVoiceService.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 17.11.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import "OPUIEnrollVoiceService.h"

@interface OPUIEnrollVoiceService()

@property (nonatomic) id<IOPCTransportProtocol> service;

@end

@implementation OPUIEnrollVoiceService

-(void)setService:(id<IOPCTransportProtocol>)service{
    _service = service;
}

-(void)processVoice:(NSData *)data
     withPassphrase:(NSString *)passphrase
        withHandler:(OPUIResultBlock)handler {
    [self.service addVoiceFile:data
                withPassphrase:passphrase
           withCompletionBlock:^(NSDictionary *responceObject, NSError *error) {
               handler(responceObject,error);
           }];
}

@end

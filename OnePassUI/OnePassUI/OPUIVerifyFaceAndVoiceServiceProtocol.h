//
//  OPUIFaceAndVoiceService.h
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 22.11.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OnePassCore/OnePassCore.h>
#import <CoreImage/CoreImage.h>

typedef void (^OPUIVerifyResultBlock) (NSDictionary *result, NSError *error);

@protocol OPUIVerifyFaceAndVoiceServiceProtocol <NSObject>

-(id)initWithService:(id<IOPCTransportProtocol>)service;

-(void)startSessionForUser:(NSString *)user
               withHandler:(OPUIVerifyResultBlock)handler;

-(void)verifyPhoto:(CIImage *)image
          andVoice:(NSData *)voice
    withHandler:(OPUIVerifyResultBlock)handler;

@end

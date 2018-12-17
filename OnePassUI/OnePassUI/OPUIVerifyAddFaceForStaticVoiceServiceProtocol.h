//
//  OPUIVerifyAddFaceForStaticVoiceServiceProtocol.h
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 24.08.2018.
//  Copyright © 2018 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OnePassCore/OnePassCore.h>
#import "CIImage+Extra.h"

typedef void (^OPUIVerifyAddFaceResultBlock) (NSDictionary *result, NSError *error);

@protocol OPUIVerifyAddFaceForStaticVoiceServiceProtocol <NSObject>

-(void)setService:(id<IOPCTransportProtocol>)service;

-(void)setUser:(NSString *)user;

-(void)addPhoto:(CIImage *)photo
    withHandler:(OPUIVerifyAddFaceResultBlock)handler;

@end


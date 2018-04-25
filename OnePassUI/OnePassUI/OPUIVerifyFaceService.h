//
//  OPUIVerifyByFaceService.h
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 16.11.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OPUIVerifyFaceViewProtocol.h"

typedef void (^OPUIVerifyResultBlock) (NSDictionary *result, NSError *error);

@protocol OPUIVerifyFaceServiceProtocol

-(void)attachView:(id<OPUIVerifyFaceViewProtocol>)view;
-(void)deattachView;

-(void)verifyPhoto:(CIImage *)photo
       withHandler:(OPUIVerifyResultBlock)handler;

@end

@interface OPUIVerifyFaceService : NSObject<OPUIVerifyFaceServiceProtocol>

@end

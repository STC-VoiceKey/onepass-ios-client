//
//  STCUILoaderProtocol.h
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 14.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OnePassCore/OnePassCore.h>
#import "IOPCRCaptureManager.h"

typedef void (^ResultBlock)(BOOL);

@protocol STCUILoaderProtocol <NSObject>

@required
-(UIViewController *)enrollUILoadWithService:(id<ITransport>)service withCaptureManager:(id<IOPCRCaptureManager>)manager;
-(UIViewController *)verifyUILoadWithService:(id<ITransport>)service withCaptureManager:(id<IOPCRCaptureManager>)manager;

-(void)setEnrollResultBlock:(ResultBlock)block;
-(ResultBlock)enrollResultBlock;

-(void)setVerifyResultBlock:(ResultBlock)block;
-(ResultBlock)verifyResultBlock;
@end

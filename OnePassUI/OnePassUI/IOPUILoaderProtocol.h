//
//  IOPUILoaderProtocol.h
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 14.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OnePassCore/OnePassCore.h>
#import <OnePassCapture/OnePassCapture.h>

/**
 Is the block which is called when the result of the verification or the registration is received

 @param result YES, if the result is successful
 @param score The additional information about the result of verification or registration
 */
typedef void (^ResultBlock)(BOOL result,NSDictionary* score);

/**
 Is the 'IOPUILoaderProtocol' provides an ability to start verification or registration
 */
@protocol IOPUILoaderProtocol <NSObject>

@required

/**
 Starts an enrollment process with the capture manager and the transport service

 @param service The 'IOPCTransportProtocol' implementation
 @param manager The 'IOPCCaptureManagerProtocol' implementation
 @return The initial view controller of the enrollment
 */
-(UIViewController *)enrollUILoadWithService:(id<IOPCTransportProtocol>)service
                          withCaptureManager:(id<IOPCCaptureManagerProtocol>)manager;

/**
 Starts a verification process with the capture manager and the transport service
 
 @param service The 'IOPCTransportProtocol' implementation
 @param manager The 'IOPCCaptureManagerProtocol' implementation
 @return The initial view controller of the verification
 */
-(UIViewController *)verifyUILoadWithService:(id<IOPCTransportProtocol>)service
                          withCaptureManager:(id<IOPCCaptureManagerProtocol>)manager;

/**
 Setter for the block called when the enroloment is complete
 @param block The block
 */
-(void)setEnrollResultBlock:(ResultBlock)block;

/**
 Getter for the block called when the enroloment is complete

 @return The block
 */
-(ResultBlock)enrollResultBlock;

/**
 Setter for the block called when the verification is complete
 @param block The block
 */
-(void)setVerifyResultBlock:(ResultBlock)block;

/**
 Getter for the block called when the verification is complete
 
 @return The block
 */
-(ResultBlock)verifyResultBlock;

@end

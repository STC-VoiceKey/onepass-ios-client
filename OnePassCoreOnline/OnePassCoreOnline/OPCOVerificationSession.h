//
//  OPCOVerificationSession.h
//  OnePassCoreOnline
//
//  Created by Soloshcheva Aleksandra on 24.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OnePassCore/OnePassCore.h>

/**
 Is the implementation of 'IOPCVerificationSessionProtocol' for the online version.\n
 The verification session is recived from the server
 */
@interface OPCOVerificationSession : NSObject<IOPCVerificationSessionProtocol>

/**
 The unique identifier of the verification session./n
 Is the implementation of required protocol method.
 */
@property (nonatomic) NSString *verificationSessionID;

/**
 The passphrase is received from the server be used for the verification/n
 Is the implementation of required protocol method.
 */
@property (nonatomic) NSString *passphrase;

///---------------------
/// @name Initialization
///---------------------

/**
 Creates and returns an `OPCOVerificationSession` object with specific JSON.
 @code
 JSON example
 {
    password = "six zero two seven eight";
    verificationId = "f64c8429-20bd-4ab2-b9d9-9b7a5b97b0c5";
 }
 @endcode
 @param json The JSON containing data
 @return The newly-initialized 'IOPCVerificationSessionProtocol' instance
 */
-(id)initWithJSON:(NSDictionary *)json;

@end

//
//  IOPCVerificationSessionProtocol.h
//  OnePassCore
//
//  Created by Soloshcheva Aleksandra on 24.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
  The 'IOPCPersonProtocol' defines an interface which provides the verification session data
 */
@protocol IOPCVerificationSessionProtocol <NSObject>

@required

/**
 The identificator of the verification session
 Must be used for any verification actions

 @return The verification session identifier
 */
-(NSString *)verificationSessionID;

/**
 The passphrase that should be used for the verification
 
 @return The passphrase
 */
-(NSString *)passphrase;

@end

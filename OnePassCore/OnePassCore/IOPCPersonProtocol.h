//
//  IOPCPersonProtocol.h
//  OnePassCore
//
//  Created by Soloshcheva Aleksandra on 15.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 The 'IOPCPersonProtocol' defines the interface for working with the person
 */
@protocol IOPCPersonProtocol <NSObject>

@required

/**
 The unique identifier of the person
 */
-(NSString *)userID;

/**
 Shows that the person is completely enrolled
 @return YES, if the person is fully enrolled
 @warning The person is successfully enrolled when it consists of 2 models the first model is the face one the second model is the voice  one containing 3 samples
 */
-(BOOL)isFullEnroll;

@end

//
//  NSURLResponse+IsSuccess.h
//  OnePassCoreOnline
//
//  Created by Soloshcheva Aleksandra on 28.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
  Category makes more suitable the checking that the request is successful 
 */
@interface NSURLResponse (IsSuccess)

/**
 Checks statusCode is 200 or 204
 @return YES, if the condition is satisfied
 */
-(BOOL)isSuccess;

/**
 Checks statusCode is 404
 @return YES, if the condition is satisfied
 */
-(BOOL)is404;

-(BOOL)is500;

-(NSInteger)statusCode;

@end

//
//  STCError.h
//  OnePassCore
//
//  Created by Soloshcheva Aleksandra on 29.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STCError : NSError

-(NSError *)stcErrorWithCode:(NSInteger)code withDescription:(NSString *)descriptor;

@end

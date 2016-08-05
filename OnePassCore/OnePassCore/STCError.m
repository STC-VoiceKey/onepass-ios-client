//
//  STCError.m
//  OnePassCore
//
//  Created by Soloshcheva Aleksandra on 29.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "STCError.h"

static NSString *speechProDomain = @"com.speachpro.onepass";

@implementation STCError

-(NSError *)stcErrorWithCode:(NSInteger)code withDescription:(NSString *)descriptor{

    return [NSError errorWithDomain:speechProDomain
                               code:code
                           userInfo:@{ NSLocalizedDescriptionKey: descriptor }];
             
}



@end

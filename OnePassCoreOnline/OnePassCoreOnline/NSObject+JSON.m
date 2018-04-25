//
//  NSObject+JSON.m
//  OpePassOnlineDemo
//
//  Created by Soloshcheva Aleksandra on 17.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "NSObject+JSON.h"

@implementation NSObject (JSON)

- (NSString *)JSONString{
    NSError *error = nil;
    NSData  *data = [NSJSONSerialization dataWithJSONObject:self options:NO error:&error];
    return [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];;
}

@end

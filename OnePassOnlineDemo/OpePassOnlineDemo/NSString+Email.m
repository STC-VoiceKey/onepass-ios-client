//
//  NSString+Email.m
//  OnePassOnlineDemo
//
//  Created by Soloshcheva Aleksandra on 30.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "NSString+Email.h"

@implementation NSString (Email)

- (BOOL) isValidEmail
{
    if (!self.length) return NO;
    
    NSString *regExPattern = @"^[A-ZА-Я0-9._%+-]+@[A-ZА-Я0-9.-]+\\.[A-ZА-Я]{2,4}$";
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern
                                                                      options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:self options:0 range:NSMakeRange(0, [self length])];
    
    return (regExMatches > 0);
}

@end

//
//  NSObject+Resolution.m
//  OnePassCaptureStandard
//
//  Created by Soloshcheva Aleksandra on 24.01.2018.
//  Copyright © 2018 Speech Technology Center. All rights reserved.
//

#import "NSObject+Resolution.h"

static NSString *kOnePassResolution = @"kOnePassResolution_v31";

@implementation NSObject (Resolution)

- (BOOL)isSmallResolution {
    
    if([NSUserDefaults.standardUserDefaults valueForKey:kOnePassResolution]) {
        return [NSUserDefaults.standardUserDefaults boolForKey:kOnePassResolution];
    }
    
    return self.defaultResolution;
}

-(BOOL)defaultResolution {
    BOOL resolution = [[NSBundle.mainBundle objectForInfoDictionaryKey:@"isSmallResolution"] boolValue];
    return resolution;
}

@end

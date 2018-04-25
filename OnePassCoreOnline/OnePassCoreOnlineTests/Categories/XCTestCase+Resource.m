//
//  XCTestCase+Resource.m
//  OnePassCoreOnlineTests
//
//  Created by Soloshcheva Aleksandra on 31.10.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import "XCTestCase+Resource.h"

@implementation XCTestCase (Resource)

-(NSData *)voiceFor:(NSString *)voice {
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    NSString *path = [bundle pathForResource:voice ofType:@"wav"];
    NSData   *wav = [[NSData alloc] initWithContentsOfFile:path];
    return wav;
}

-(NSData *)faceFor:(NSString *)face {
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    NSString *path = [bundle pathForResource:face ofType:@"jpg"];
    NSData   *jpeg = [[NSData alloc] initWithContentsOfFile:path];
    return jpeg ;
}

@end

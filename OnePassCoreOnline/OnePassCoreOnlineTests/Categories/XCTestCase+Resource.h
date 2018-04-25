//
//  XCTestCase+Resource.h
//  OnePassCoreOnlineTests
//
//  Created by Soloshcheva Aleksandra on 31.10.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface XCTestCase (Resource)

-(NSData *)voiceFor:(NSString *)voice;
-(NSData *)faceFor:(NSString *)face;

@end

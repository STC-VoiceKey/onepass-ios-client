//
//  OPCSManagersTests.m
//  OnePassCaptureStandardTests
//
//  Created by Soloshcheva Aleksandra on 08.11.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OPCSCaptureResourceManager.h"
#import "OPCSCaptureBaseManager.h"

@interface OPCSManagersTests : XCTestCase

@end

@implementation OPCSManagersTests

- (void)testCaptureResourceManager{
    OPCSCaptureResourceManager *captureManager = [OPCSCaptureResourceManager sharedInstance];
    
    XCTAssertNil(captureManager.photoManager,@"photoManager is nil");
    XCTAssertNil(captureManager.voiceManager,@"voiceManager is nil");
    XCTAssertNil(captureManager.videoManager,@"videoManager is nil");
}

@end

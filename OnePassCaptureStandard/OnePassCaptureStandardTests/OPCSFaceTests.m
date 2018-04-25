//
//  OnePassCaptureStandardTests.m
//  OnePassCaptureStandardTests
//
//  Created by Soloshcheva Aleksandra on 03.11.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OnePassCapture/OnePassCapture.h>
#import "OPCSFaceManager.h"

@interface OPCSFaceTests : XCTestCase

@property (nonatomic) id<IOPCCheckFacePosition,IOPCInterfaceOrientationProtocol> faceManager;

@end

@implementation OPCSFaceTests

- (void)setUp {
    [super setUp];
    
    self.faceManager = [[OPCSFaceManager alloc] init];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testCheckPosition {
    BOOL result = [self.faceManager isSuitableFaceByRightEye:CGPointMake(353, 351)
                                                   byLeftEye:CGPointMake(270, 367)
                                                      inSize:CGSizeMake(480, 640)];
    XCTAssertFalse(result);
    
    result = [self.faceManager isSuitableFaceByRightEye:CGPointMake(356, 253)
                                              byLeftEye:CGPointMake(259, 263)
                                                 inSize:CGSizeMake(480, 640)];
    XCTAssertFalse(result);
    
    result = [self.faceManager isSuitableFaceByRightEye:CGPointMake(349, 190)
                                              byLeftEye:CGPointMake(190, 190)
                                                 inSize:CGSizeMake(480, 640)];
    XCTAssertFalse(result);
    
    result = [self.faceManager isSuitableFaceByRightEye:CGPointMake(294, 377)
                                              byLeftEye:CGPointMake(177, 389)
                                                 inSize:CGSizeMake(480, 640)];

    XCTAssertTrue(result);
}

@end

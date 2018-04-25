//
//  OPCSVideoConverterTests.m
//  OnePassCaptureStandardTests
//
//  Created by Soloshcheva Aleksandra on 07.11.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "OPCSVideoConverter.h"

@interface OPCSVideoConverterTests : XCTestCase

@property (nonatomic) OPCSVideoConverter *videoConverter;

@end

@implementation OPCSVideoConverterTests

- (void)setUp {
    [super setUp];
    
    self.videoConverter = [[OPCSVideoConverter alloc] initWithAssetURL:self.videoUrl
                                                           toOutputURL:self.outputUrl];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testVideoConverter {
     XCTestExpectation *expectation = [self expectationWithDescription:@"Start Export"];
    [self.videoConverter exportAsynchronouslyWithCompletionHandler:^(NSError *error) {
        XCTAssertNil(error);
        NSData *data = [NSData dataWithContentsOfURL:self.outputUrl];
        XCTAssertTrue(data.length < 200000);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:20.0 handler:nil];
}



-(NSURL *)videoUrl {
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    NSString *path = [bundle pathForResource:@"verify_for_test" ofType:@"mov"];
    return [NSURL fileURLWithPath:path] ;
}

-(NSURL *)outputUrl {
    NSString *documentsDirectory =  NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *path = [NSString stringWithFormat:@"%@/%@", documentsDirectory , @"converted_video.mov"];
    return [NSURL fileURLWithPath:path];
}

@end

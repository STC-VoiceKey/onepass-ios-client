//
//  OPCOTestPerson.m
//  OnePassCoreOnlineTests
//
//  Created by Soloshcheva Aleksandra on 30.10.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//
#import <XCTest/XCTest.h>
#import <OnePassCore/OnePassCore.h>
#import <OnePassCoreOnline/OnePassCoreOnline.h>
#import "OPCOSession.h"

@interface OPCOTestPersonFail : XCTestCase

@property (nonatomic) id<IOPCTransportProtocol> transport;
@property (nonatomic) NSString *person;

@end

@implementation OPCOTestPersonFail

- (void)setUp {
    [super setUp];
    
    self.person = [NSUUID UUID].UUIDString;
    
    self.transport = [[OPCOManager alloc] init];
    [self.transport setServerURL:@"https://onepass.tech/vkop/rest"];
    [self.transport setSessionData:[OPCOSession goodSessionData]];
}

- (void)tearDown {
    self.transport = nil;
    [super tearDown];
}

-(void)testReadNonexistentPerson {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Reading nonexistent person"];
    [self.transport createSessionWithCompletionBlock:^(NSDictionary *responceObject, NSError *error) {
        [self.transport readPerson:self.person
               withCompletionBlock:^(NSDictionary *responceObject, NSError *error) {
                   XCTAssertNotNil( error, @"");
                   XCTAssertEqual( error.code, 400, @"");
                   [expectation fulfill];
               }];
    }];
    [self waitForExpectationsWithTimeout:20.0 handler:nil];
}

@end

//
//  OPCOTests.m
//  OnePassCoreOnlineTests
//
//  Created by Soloshcheva Aleksandra on 27.10.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OnePassCore/OnePassCore.h>
#import <OnePassCoreOnline/OnePassCoreOnline.h>
#import "OPCOSession.h"

@interface OPCOTestSessionFail : XCTestCase

@property (nonatomic) id<IOPCTransportProtocol> transport;


@end

@implementation OPCOTestSessionFail

- (void)setUp {
    [super setUp];

    self.transport = [[OPCOManager alloc] init];
    [self.transport setServerURL:@"https://onepass.tech/vkop/rest"];

}

-(void)testCheckReadingWithoutSession{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Reading without session"];
    
    [self.transport readPerson:@"testperson"
           withCompletionBlock:^( NSDictionary *responceObject, NSError *error) {
               XCTAssertNotNil(error,@"");
               XCTAssertTrue([error.localizedDescription isEqualToString:@"Session id is null"],@"");
               [expectation fulfill];
           }];
    
    [self waitForExpectationsWithTimeout:20.0 handler:nil];
}

-(void)testSessionCreationWithFailSessionData {
    [self.transport setSessionData:[OPCOSession badSessionData]];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Create session with Fail Session Data"];
    [self.transport createSessionWithCompletionBlock:^(NSDictionary *responceObject, NSError *error) {
        XCTAssertNotNil(error,@"");
        XCTAssertTrue([error.localizedDescription isEqualToString:@"Failed to login user adminFail. Error: User 'adminFail' is not registered in security database."],@"");
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

@end

//
//  OPCOTestFace.m
//  OnePassCoreOnlineTests
//
//  Created by Soloshcheva Aleksandra on 30.10.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <OnePassCore/OnePassCore.h>
#import <OnePassCoreOnline/OnePassCoreOnline.h>
#import "OPCOSession.h"
#import "XCTestCase+Resource.h"

@interface OPCOTestFaceFail : XCTestCase

@property (nonatomic) id<IOPCTransportProtocol> transport;
@property (nonatomic) NSString *person;

@end

@implementation OPCOTestFaceFail

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

-(void)testEyesAreClosed {
    [self checkPortraitWithImage:@"right_eye_closed" forError:@"Portrait characteristics check failed. Eyes are closed."];
}

-(void)testDarkglasses {
    [self checkPortraitWithImage:@"darkglasses" forError:@"Portrait characteristics check failed. Tinted glass detected."];
}

-(void)testFaceRight {
    [self checkPortraitWithImage:@"face_right" forError:@"Portrait characteristics check failed. Face is not positioned frontal."];
}

-(void)testFaceLeft {
    [self checkPortraitWithImage:@"face_left" forError:@"Portrait characteristics check failed. Face is not positioned frontal."];
}

-(void)testFaceDown {
    [self checkPortraitWithImage:@"face_down" forError:@"Portrait characteristics check failed. Face is not positioned frontal."];
}

-(void)checkPortraitWithImage:(NSString *)fileName forError:(NSString *)errorName {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Portrait characteristics check failed"];
    [self.transport createSessionWithCompletionBlock:^(NSDictionary *responceObject, NSError *error) {
        XCTAssertNil( error, @"");
        XCTAssertNil( responceObject, @"");
        [self.transport createPerson:self.person
                 withCompletionBlock:^(NSDictionary *responceObject, NSError *error) {
                     XCTAssertNil( error, @"");
                     XCTAssertNil( responceObject, @"");
                     NSData *face = [self faceFor:fileName];
                     [self.transport addFaceSample:face
                               withCompletionBlock:^(NSDictionary *responceObject, NSError *error) {
                                   XCTAssertNotNil( error, @"");
                                   XCTAssertTrue( [error.localizedDescription isEqualToString:errorName], @"");
                                   [self.transport deletePerson:self.person
                                            withCompletionBlock:^(NSDictionary *responceObject, NSError *error) {
                                                XCTAssertNil( error, @"");
                                                XCTAssertNil( responceObject, @"");
                                                [self.transport deleteSessionWithCompletionBlock:^(NSDictionary *responceObject, NSError *error) {
                                                    XCTAssertNil( error, @"");
                                                    XCTAssertNil( responceObject, @"");
                                                    [expectation fulfill];
                                                }];
                                            }];
                               }];
                     
                     
                 }];
    }];
    [self waitForExpectationsWithTimeout:20.0 handler:nil];
}

@end

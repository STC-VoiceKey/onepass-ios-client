//
//  OPCOTestVoiceFail.m
//  OnePassCoreOnlineTests
//
//  Created by Soloshcheva Aleksandra on 31.10.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <OnePassCore/OnePassCore.h>
#import <OnePassCoreOnline/OnePassCoreOnline.h>
#import "OPCOSession.h"
#import "XCTestCase+Resource.h"

@interface OPCOTestVoiceFail : XCTestCase

@property (nonatomic) id<IOPCTransportProtocol> transport;
@property (nonatomic) NSString *person;

@end

@implementation OPCOTestVoiceFail

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

-(void)testBadPronunciation {
    NSString *errorName = [NSString stringWithFormat:@"Person %@ has poor password pronunciation.", self.person];
    [self checkVoice:@"девять восемь семь шесть пять четыре три два один ноль" forPassphrase:@"nine five zero" forError:errorName];
}

-(void)checkVoice:(NSString *)fileName forPassphrase:(NSString *)passphrase forError:(NSString *)errorName {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Portrait characteristics check failed"];
    [self.transport createSessionWithCompletionBlock:^(NSDictionary *responceObject, NSError *error) {
        XCTAssertNil( error, @"");
        XCTAssertNil( responceObject, @"");
        [self.transport createPerson:self.person
                 withCompletionBlock:^(NSDictionary *responceObject, NSError *error) {
                     XCTAssertNil( error, @"");
                     XCTAssertNil( responceObject, @"");
                     NSData *voice = [self voiceFor:fileName];
                     [self.transport addVoiceFile:voice
                                   withPassphrase:passphrase
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

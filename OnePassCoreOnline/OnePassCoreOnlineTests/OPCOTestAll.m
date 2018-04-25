//
//  OPCOTestEnrollment.m
//  OnePassCoreOnlineTests
//
//  Created by Soloshcheva Aleksandra on 31.10.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OnePassCore/OnePassCore.h>
#import <OnePassCoreOnline/OnePassCoreOnline.h>
#import <AVFoundation/AVFoundation.h>
#import "XCTestCase+Resource.h"
#import "OPCOSession.h"

@interface OPCOTestAll : XCTestCase

@property (nonatomic) id<IOPCTransportProtocol> transport;
@property (nonatomic) NSString *person;
@property (nonatomic) id<IOPCVerificationSessionProtocol> session;

@property (nonatomic) AVAssetExportSession *exporter;

@end

@implementation OPCOTestAll

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

-(void)test{
    
    [self startSession];
    [self createPerson];
    [self addFace];
    [self addVoices];
    [self checkPerson];
    
    [self startVerification];

    [self addVideo];
    
    [self verifyScore];
    [self verifyResult];
    
    [self deletePerson];
    [self deleteSession];
}

-(void)startSession {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Start Session"];
    [self.transport createSessionWithCompletionBlock:^(NSDictionary *responceObject, NSError *error) {
        XCTAssertNil( error, @"");
        XCTAssertNil( responceObject, @"");
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:20.0 handler:nil];
}

-(void)createPerson {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Create Person"];
    [self.transport createPerson:self.person
             withCompletionBlock:^(NSDictionary *responceObject, NSError *error) {
                 XCTAssertNil( error, @"");
                 XCTAssertNil( responceObject, @"");
                 [expectation fulfill];
             }];
    
    [self waitForExpectationsWithTimeout:20.0 handler:nil];
}

-(void)addFace {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Add Face to Person"];
    NSData *face = [self faceFor:@"face"];
    [self.transport addFaceSample:face
              withCompletionBlock:^(NSDictionary *responceObject, NSError *error) {
                  XCTAssertNil( error, @"");
                  XCTAssertNil( responceObject, @"");
                  [expectation fulfill];
              }];
    [self waitForExpectationsWithTimeout:20.0 handler:nil];
}

-(void)addVoices {
    [self addVoice:@"ноль один два три четыре пять шесть семь восемь девять"];
    [self addVoice:@"девять восемь семь шесть пять четыре три два один ноль"];
    [self addVoice:@"три один восемь два девять шесть пять ноль семь четыре"];
}

-(void)addVoice:(NSString *)voice {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Add Voice to Person"];
    NSData *voiceData = [self voiceFor:voice];
    [self.transport addVoiceFile:voiceData
                  withPassphrase:voice
             withCompletionBlock:^(NSDictionary *responceObject, NSError *error) {
                 XCTAssertNil(error,@"");
                 XCTAssertNil(responceObject,@"");
                 [expectation fulfill];
             }];
    [self waitForExpectationsWithTimeout:20.0 handler:nil];
}

-(void)checkPerson {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Check Person"];
    
    [self.transport readPerson:self.person
           withCompletionBlock:^(NSDictionary *responceObject, NSError *error) {
               XCTAssertNil( error, @"");
               XCTAssertNotNil(responceObject, @"");
               
               OPCOPerson *person = [[OPCOPerson alloc] initWithJSON:responceObject];
               
               XCTAssertNotNil(person);
               XCTAssertTrue(person.isFullEnroll);
               
               [expectation fulfill];
           }];
    
    [self waitForExpectationsWithTimeout:20.0 handler:nil];
}

-(void)startVerification {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Start Verification Session"];
    
    [self.transport startVerificationSession:self.person
                         withCompletionBlock:^(id<IOPCVerificationSessionProtocol> session, NSError *error) {
                             XCTAssertNil( error, @"");
                             XCTAssertNotNil(session, @"");
                             self.session = session;
                             [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:20.0 handler:nil];
}

-(void)addVideo {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Merge Video"];
    
    [self mergeVideoForPhrase:self.session.passphrase
                 withCallback:^(NSString *filepath) {
                     NSData *videoData = [NSData dataWithContentsOfFile:filepath];
                     [self.transport addVerificationVideo:videoData
                                           withPassphrase:self.session.passphrase
                                      withCompletionBlock:^(NSDictionary *responceObject, NSError *error) {
                                                            XCTAssertNil( error, @"");
                                                            [expectation fulfill];
                                                        }];
                                                    }];
    
    [self waitForExpectationsWithTimeout:20.0 handler:nil];
}

-(void)verifyScore {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Get Score"];
    
    [self.transport verifyScoreWithCompletionBlock:^(NSDictionary *responceObject, NSError *error) {
        XCTAssertNil( error, @"");
        XCTAssertNotNil( responceObject, @"");
        
        float dynamicVoice = [responceObject[@"dynamicVoice"] floatValue];
        XCTAssertTrue(dynamicVoice > 80.0, @"dynamicVoice score < 80");
        
        float face = [responceObject[@"face"] floatValue];
        XCTAssertTrue(face > 80.0, @"face score < 80");
        
        BOOL isAlive = [responceObject[@"isAlive"] boolValue];
        XCTAssertTrue(isAlive, @"isAlive false");

        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:20.0 handler:nil];
}

-(void)verifyResult{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Get Score"];
    
    [self.transport verifyResultWithCompletionBlock:^(NSDictionary *responceObject, NSError *error) {
        XCTAssertNil( error, @"");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:20.0 handler:nil];
}

-(void)deletePerson {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Remove Person"];    
    [self.transport deletePerson:self.person
             withCompletionBlock:^(NSDictionary *responceObject, NSError *error) {
                 XCTAssertNil(error,@"");
                 XCTAssertNil(responceObject,@"");
               [expectation fulfill];
           }];
    [self waitForExpectationsWithTimeout:20.0 handler:nil];
}

-(void)deleteSession {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Remove Session"];
    [self.transport deleteSessionWithCompletionBlock:^(NSDictionary *responceObject, NSError *error) {
        XCTAssertNil(error,@"");
        XCTAssertNil(responceObject,@"");
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:20.0 handler:nil];
}

-(void)mergeVideoForPhrase:(NSString *)phrase
              withCallback:(void (^)(NSString *filepath))block{
    
    CGFloat totalDuration = 0;
    
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    
    AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    
    CMTime insertTime = kCMTimeZero;
    
    NSArray<NSString *> *filenames = [phrase componentsSeparatedByString:@" "];
    
    for (NSString * file in filenames) {
        NSString *fileName = [NSString stringWithFormat:@"%@/%@.mov", [NSBundle bundleForClass:self.class].resourcePath, file];
        NSURL    *fileURL  = [NSURL fileURLWithPath:fileName];
        
        AVAsset *asset = [AVAsset assetWithURL:fileURL];
        
        CMTimeRange timeRange = CMTimeRangeMake(kCMTimeZero, asset.duration);
        
        [videoTrack insertTimeRange:timeRange
                            ofTrack:[asset tracksWithMediaType:AVMediaTypeVideo].firstObject
                             atTime:insertTime
                              error:nil];
        
        [audioTrack insertTimeRange:timeRange
                            ofTrack:[asset tracksWithMediaType:AVMediaTypeAudio].firstObject
                             atTime:insertTime
                              error:nil];
        
        insertTime = CMTimeAdd( insertTime, asset.duration);
    }
    
    NSString *documentsDirectory =  NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *myDocumentPath = [NSString stringWithFormat:@"%@/%@", documentsDirectory , @"merge_video.mp4"];
    
    if([NSFileManager.defaultManager fileExistsAtPath:myDocumentPath]){
        [NSFileManager.defaultManager removeItemAtPath:myDocumentPath error:nil];
    }
    
    self.exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
    self.exporter.outputURL = [NSURL fileURLWithPath:myDocumentPath];
    self.exporter.outputFileType = @"com.apple.quicktime-movie";
    self.exporter.shouldOptimizeForNetworkUse = YES;
    
    [self.exporter exportAsynchronouslyWithCompletionHandler:^{
        block(myDocumentPath);
    }];
}

@end

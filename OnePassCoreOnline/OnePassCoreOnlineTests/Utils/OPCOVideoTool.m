//
//  OPCOVideoTool.m
//  OnePassCoreOnlineTests
//
//  Created by Soloshcheva Aleksandra on 01.11.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import <XCTest/XCTest.h>
#import "OPCOVideoTool.h"

@implementation OPCOVideoTool

+(NSString *)mergeVideoForPhrase:(NSString *)phrase {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Start Verification Session"];
    
    CGFloat totalDuration = 0;
    totalDuration = 0;
    
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    
    AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    
    CMTime insertTime = kCMTimeZero;
    
    NSArray<NSString *> *filenames = [phrase componentsSeparatedByString:@" "];
    
    for (NSString * file in filenames) {
        NSString *fileName = [NSString stringWithFormat:@"%@.mov", file];
        
        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:fileName withExtension:nil];
        // NSURL *fileURL = [NSURL fileURLWithPath:fileName];
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

    NSString *documentsDirectory =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *myDocumentPath = [NSString stringWithFormat:@"%@/%@", documentsDirectory , @"merge_video.mp4"];

    if([[NSFileManager defaultManager] fileExistsAtPath:myDocumentPath]){
        [[NSFileManager defaultManager] removeItemAtPath:myDocumentPath error:nil];
    }
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
    exporter.outputURL = [NSURL fileURLWithPath:myDocumentPath];
    exporter.outputFileType = @"com.apple.quicktime-movie";
    exporter.shouldOptimizeForNetworkUse = YES;
    
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:20.0 handler:nil];
}

@end

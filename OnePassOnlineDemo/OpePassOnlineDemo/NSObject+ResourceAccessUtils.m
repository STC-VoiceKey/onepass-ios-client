//
//  NSObject+ResourceAccessUtils.m
//  OnePassOnlineDemo
//
//  Created by Soloshcheva Aleksandra on 26.09.17.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import "NSObject+ResourceAccessUtils.h"
#import <AVFoundation/AVFoundation.h>

@implementation NSObject (ResourceAccessUtils)

-(BOOL)isMicrophoneAvailable{
    if ([AVAudioSession sharedInstance].recordPermission==AVAudioSessionRecordPermissionGranted) {
        return YES;
    }
    return NO;
}

-(BOOL)isCameraAvailable{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus!=AVAuthorizationStatusDenied) {
        return YES;
    }
    return NO;
}

-(BOOL)isMicrophoneUndetermined{
    if ([AVAudioSession sharedInstance].recordPermission==AVAudioSessionRecordPermissionUndetermined) {
        return YES;
    }
    return NO;
}
-(BOOL)isCameraUndetermined{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus==AVAuthorizationStatusNotDetermined) {
        return YES;
    }
    return NO;
}

-(void)askCameraPermissionWithHandler:(void (^)(BOOL granted))handler{
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:handler];
}

-(void)askMicPermissionWithHandler:(void (^)(BOOL granted))handler{
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:handler];
}

@end

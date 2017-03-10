//
//  UIViewController+ResourceAccessUtils.m
//  OnePassOnlineDemo
//
//  Created by Soloshcheva Aleksandra on 17.02.17.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import "UIViewController+ResourceAccessUtils.h"
#import <AVFoundation/AVFoundation.h>

@implementation UIViewController (ResourceAccessUtils)

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

-(void)askCameraPermission{
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        
    }];

}

-(void)askMicPermission{

    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
        
    }];
}
@end

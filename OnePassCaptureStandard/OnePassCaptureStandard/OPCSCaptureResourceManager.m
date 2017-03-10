//
//  OPCRCaptureManager.m
//  OnePassCaptureStandard
//
//  Created by Soloshcheva Aleksandra on 08.08.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPCSCaptureResourceManager.h"
#import "OPCSCaptureVideoManager.h"
#import "OPCSCapturePhotoManager.h"
#import "OPCSCaptureVoice2BufferManager.h"

@implementation OPCSCaptureResourceManager

+(id<IOPCCaptureManagerProtocol>)sharedInstance{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[OPCSCaptureResourceManager alloc] init];
    });
    return sharedInstance;
}

///-----------------------------------------------------------
///     @name       IOPCCaptureManagerProtocol
///-----------------------------------------------------------

-(id<IOPCCaptureVideoManagerProtocol,IOPCPortraitFeaturesProtocol,IOPCEnvironmentProtocol>)videoManager{
     return [[OPCSCaptureVideoManager alloc] init];
}

-(id<IOPCCaptureVoiceManagerProtocol>)voiceManager{
    return [[OPCSCaptureVoice2BufferManager alloc] init];
}

-(id<IOPCCapturePhotoManagerProtocol,IOPCPortraitFeaturesProtocol,IOPCEnvironmentProtocol>)photoManager{
    return [[OPCSCapturePhotoManager alloc] init];
}

@end

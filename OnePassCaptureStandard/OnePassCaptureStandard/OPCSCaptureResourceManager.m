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
#import "OPCSOSXCapturePhotoManager.h"

@interface OPCSCaptureResourceManager()

@property (nonatomic) OPCSCaptureVideoManager        *videoResourceManager;
@property (nonatomic) OPCSCaptureVoice2BufferManager *voiceResourceManager;
@property (nonatomic) OPCSCapturePhotoManager        *photoResourceManager;

@end

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
    static dispatch_once_t oncePhoto;
    dispatch_once(&oncePhoto, ^{
        self.videoResourceManager = [[OPCSCaptureVideoManager alloc] init];
    });
    return self.videoResourceManager;
}

-(id<IOPCCaptureVoiceManagerProtocol>)voiceManager{
    static dispatch_once_t onceVoice;
    dispatch_once(&onceVoice, ^{
        self.voiceResourceManager = [[OPCSCaptureVoice2BufferManager alloc] init];
    });
    return self.voiceResourceManager;
}

-(id< IOPCCapturePhotoManagerProtocol,
      IOPCPortraitFeaturesProtocol,
      IOPCEnvironmentProtocol,
      IOPCInterfaceOrientationProtocol>)photoManager{
    
    static dispatch_once_t oncePhoto;
    dispatch_once(&oncePhoto, ^{
#ifndef OSX
        self.photoResourceManager = [[OPCSCapturePhotoManager alloc] init];
#else
        self.photoResourceManager = [[OPCSOSXCapturePhotoManager alloc] init];
#endif
    });
    return self.photoResourceManager;
}

@end

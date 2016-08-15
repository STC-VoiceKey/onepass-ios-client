//
//  OPCRCaptureManager.m
//  OnePassCaptureResources
//
//  Created by Soloshcheva Aleksandra on 08.08.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPCRCaptureResourceManager.h"
#import "OPCRCaptureVideoManager.h"
#import "OPCRCaptureVoiceManager.h"
#import "OPCRCapturePhotoManager.h"

#import "OPCRCaptureExtraPhotoManager.h"

@implementation OPCRCaptureResourceManager

+(id<IOPCRCaptureManager>)sharedInstance{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[OPCRCaptureResourceManager alloc] init];
    });
    return sharedInstance;
}

-(id<IOPCRCaptureVideoManager>)videoManager{
    return [[OPCRCaptureVideoManager alloc] init];
}

-(id<IOPCRCaptureVoiceManager>)voiceManager{
    return [[OPCRCaptureVoiceManager alloc] init];
}

-(id<IOPCRCapturePhotoManager,IOPCRPortraitFeatures,IOPCREnvironment>)photoManager{
#warning temporally design
    return [[OPCRCaptureExtraPhotoManager alloc] init];
   // return [[OPCRCapturePhotoManager alloc] init];
}

@end

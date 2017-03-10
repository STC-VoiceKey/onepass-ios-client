//
//  IOPCCaptureManagerProtocol.h
//  OnePassCaptureStandard
//
//  Created by Soloshcheva Aleksandra on 08.08.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IOPCCaptureVideoManagerProtocol.h"
#import "IOPCCaptureVoiceManagerProtocol.h"
#import "IOPCCapturePhotoManagerProtocol.h"

/**
 The 'IOPCCaptureManagerProtocol' provides the access to capture managers.
 */
@protocol IOPCCaptureManagerProtocol <NSObject>

@required

/**
 The newly-initialized video capture manager which can implement some of the following protocols
 The 'IOPCCaptureVideoManagerProtocol' is for video capture
 The 'IOPCPortraitFeaturesProtocol' is for portrait features checking
 The 'IOPCEnvironmentProtocol' is for environment checking

 @return The video capture manager
 */
-(id<IOPCCaptureVideoManagerProtocol,IOPCPortraitFeaturesProtocol,IOPCEnvironmentProtocol>)videoManager;

/**
 The newly-initialized voice capture manager which can implement some of the following protocols
 The 'IOPCSCaptureVoiceManagerProtocol' is for voice capture

 @return  The voice capture manager
 */
-(id<IOPCCaptureVoiceManagerProtocol>)voiceManager;

/**
 The newly-initialized photo capture manager which can implement some of the following protocols
 The 'IOPCSCapturePhotoManagerProtocol' is for photo capture
 The 'IOPCPortraitFeaturesProtocol' is for checking portrait features checking
 The 'IOPCEnvironmentProtocol' is for environment checking

 @return  The photo capture manager
 */
-(id<IOPCCapturePhotoManagerProtocol,IOPCPortraitFeaturesProtocol,IOPCEnvironmentProtocol>)photoManager;


@end

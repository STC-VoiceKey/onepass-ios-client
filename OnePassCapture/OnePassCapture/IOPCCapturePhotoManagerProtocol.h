//
//  IOPCSCapturePhotoManagerProtocol.h
//  OnePassCaptureStandard
//
//  Created by Soloshcheva Aleksandra on 08.08.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IOPCPhotoProtocol.h"
#import "IOPCLoadingImageProtocol.h"
#import "IOPCSessionProtocol.h"
#import "IOPCPortraitFeaturesProtocol.h"
#import "IOPCEnvironmentProtocol.h"

/**
 The 'IOPCSCapturePhotoManagerProtocol' provides the photo resource.
 Includes three protocols
    The 'IOPCPhotoProtocol' takes a photo and calls the 'IOPCLoadingDataProtocol' for delivering the photo
    The 'IOPCLoadingDataProtocol' transfers the received data to the recipient
    The 'IOPCSessionProtocol' controls the AVSession instance for displaying a video stream
 */
@protocol IOPCCapturePhotoManagerProtocol <IOPCPhotoProtocol,
                                     IOPCLoadingImageProtocol,
                                         IOPCSessionProtocol>
@end

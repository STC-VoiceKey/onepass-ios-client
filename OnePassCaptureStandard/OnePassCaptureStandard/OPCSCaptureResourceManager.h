//
//  OPCRCaptureManager.h
//  OnePassCaptureStandard
//
//  Created by Soloshcheva Aleksandra on 08.08.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OnePassCapture/OnePassCapture.h>

/**
 Is the implementation of 'IOPCCaptureManagerProtocol' for the standard version of the capture manager.
 */
@interface OPCSCaptureResourceManager : NSObject<IOPCCaptureManagerProtocol>

///---------------------------
/// @name Initialization
///---------------------------

/**
 The shared default instance of `IOPCCaptureManagerProtocol` initialized with default values.
 */
+(id<IOPCCaptureManagerProtocol>)sharedInstance;

@end

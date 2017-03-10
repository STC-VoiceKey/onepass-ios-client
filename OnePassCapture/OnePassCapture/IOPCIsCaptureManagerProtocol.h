//
//  IOPCIsCaptureManagerProtocol.h
//  OnePassCapture
//
//  Created by Soloshcheva Aleksandra on 09.08.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IOPCIsCaptureManagerProtocol.h"

/**
 Provides access to the resource providers implementation of 'IOPCCaptureManagerProtocol'
 Has the getter and the setter, so can be used as a property
 Should be used to transfer a resource providers between entities
 */
@protocol IOPCIsCaptureManagerProtocol <NSObject>

@required

/**
 Setter for 'IOPCCaptureManagerProtocol'
 @param captureManager The instance of 'IOPCCaptureManagerProtocol'
 */
-(void)setCaptureManager:(id<IOPCCaptureManagerProtocol>)captureManager;

/**
 Getter for 'IOPCCaptureManagerProtocol'
 @return The instance of 'IOPCCaptureManagerProtocol'
 */
-(id<IOPCCaptureManagerProtocol>)captureManager;

@end

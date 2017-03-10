//
//  OPUINavigationController.h
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 20.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OnePassCore/OnePassCore.h>
#import <OnePassCapture/OnePassCapture.h>


/**
 Is the navigation view controller which implements 'IOPCTransportableProtocol' and 'IOPCIsCaptureManagerProtocol'.
 The navigator pushes the 'IOPCTransportableProtocol' instance and the 'IOPCIsCaptureManagerProtocol' instance to all child view controllers
 */
@interface OPUINavigationController : UINavigationController<IOPCTransportableProtocol,IOPCIsCaptureManagerProtocol>

/**
 The 'IOPCTransportableProtocol' instance
 */
@property (nonatomic,strong) id<IOPCTransportProtocol>      service;

/**
 The 'IOPCIsCaptureManagerProtocol' instance
 */
@property (nonatomic,strong) id<IOPCCaptureManagerProtocol> captureManager;

@end

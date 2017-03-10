//
//  OPUINavigationController.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 20.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPUINavigationController.h"
#import <OnePassCapture/OnePassCapture.h>

@implementation OPUINavigationController

-(void)setService:(id<IOPCTransportProtocol>)service{
    
    _service = service;
    if([self.topViewController conformsToProtocol:@protocol(IOPCTransportableProtocol)] && self.service){
        id<IOPCTransportableProtocol> vcService =  (id<IOPCTransportableProtocol>) self.topViewController;
        [vcService setService:self.service];
    }
}

-(void)setCaptureManager:(id<IOPCCaptureManagerProtocol>)captureManager{
    _captureManager = captureManager;
    if([self.topViewController conformsToProtocol:@protocol(IOPCIsCaptureManagerProtocol)] && self.captureManager){
        id<IOPCIsCaptureManagerProtocol> vcCapture =  (id<IOPCIsCaptureManagerProtocol>) self.topViewController;
        [vcCapture setCaptureManager:self.captureManager];
    }
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if([viewController conformsToProtocol:@protocol(IOPCTransportableProtocol)] && self.service){
        id<IOPCTransportableProtocol> vcService =  (id<IOPCTransportableProtocol>) viewController;
        [vcService setService:self.service];
    }
    
    if([viewController conformsToProtocol:@protocol(IOPCIsCaptureManagerProtocol)] && self.captureManager){
        id<IOPCIsCaptureManagerProtocol> vcCapture =  (id<IOPCIsCaptureManagerProtocol>) viewController;
        [vcCapture setCaptureManager:self.captureManager];
    }
    
    [super pushViewController:viewController animated:animated];
}

@end

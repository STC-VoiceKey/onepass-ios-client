//
//  OPUINavigationController.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 20.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPUINavigationController.h"

@implementation OPUINavigationController

-(void)setService:(id<ITransport>)service{
    _service = service;
    if([self.topViewController conformsToProtocol:@protocol(ITransportService)] && self.service){
        id<ITransportService> vcService =  (id<ITransportService>) self.topViewController;
        [vcService setService:self.service];
    }
    
}

-(void)setCaptureManager:(id<IOPCRCaptureManager>)captureManager{
    _captureManager = captureManager;
    if([self.topViewController conformsToProtocol:@protocol(IsIOPCRCaptureManager)] && self.captureManager){
        id<IsIOPCRCaptureManager> vcCapture =  (id<IsIOPCRCaptureManager>) self.topViewController;
        [vcCapture setCaptureManager:self.captureManager];
    }
}



-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if([viewController conformsToProtocol:@protocol(ITransportService)] && self.service){
        id<ITransportService> vcService =  (id<ITransportService>) viewController;
        [vcService setService:self.service];
    }
    if([viewController conformsToProtocol:@protocol(IsIOPCRCaptureManager)] && self.captureManager){
        id<IsIOPCRCaptureManager> vcCapture =  (id<IsIOPCRCaptureManager>) viewController;
        [vcCapture setCaptureManager:self.captureManager];
    }
    
    [super pushViewController:viewController animated:animated];
}

@end

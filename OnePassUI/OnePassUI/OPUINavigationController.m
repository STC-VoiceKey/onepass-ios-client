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



-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if([viewController conformsToProtocol:@protocol(ITransportService)] && self.service){
        id<ITransportService> vcService =  (id<ITransportService>) viewController;
        [vcService setService:self.service];
    }
    [super pushViewController:viewController animated:animated];
}

@end

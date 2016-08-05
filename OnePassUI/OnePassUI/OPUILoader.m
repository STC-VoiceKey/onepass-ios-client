//
//  STCUILoader.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 14.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPUILoader.h"
#import <OnePassCore/OnePassCore.h>


@interface OPUILoader(PrivateMethods)

-(UIViewController *)loadStoriboard:(NSString *)storiboardName withService:(id<ITransport>)service;

@end

@implementation OPUILoader

+ (id<STCUILoaderProtocol>)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(UIViewController *)enrollUILoadWithService:(id<ITransport>) service{
    return [self loadStoriboard:@"Enroll" withService:service];
}

-(UIViewController *)verifyUILoadWithService:(id<ITransport>) service{
    return [self loadStoriboard:@"Verify" withService:service];
}
@end

@implementation OPUILoader(PrivateMethods)

-(UIViewController *)loadStoriboard:(NSString *)storiboardName withService:(id<ITransport>)service{
    NSBundle *frameworkBundle = [NSBundle bundleForClass:[self class]];
    UIViewController *vc = [[UIStoryboard storyboardWithName:storiboardName bundle: frameworkBundle] instantiateInitialViewController];
    if([vc conformsToProtocol:@protocol(ITransportService)]){
        id<ITransportService> vcService = (id<ITransportService>)vc;
        [vcService setService:service ];
        NSLog(@"%@",[vcService service]);
    }
    return vc;
}

@end

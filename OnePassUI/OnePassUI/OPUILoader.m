 //
//  STCUILoader.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 14.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPUILoader.h"
#import <OnePassCore/OnePassCore.h>
#import <OnePassUICommon/OnePassUICommon.h>

@interface OPUILoader()

@property (nonatomic) ResultBlock enrollResultBlock;
@property (nonatomic) ResultBlock verifyResultBlock;

@end

@interface OPUILoader(PrivateMethods)

-(UIViewController *)loadStoriboard:(NSString *)storiboardName
                        withService:(id<ITransport>)service
                 withCaptureManager:(id<IOPCRCaptureManager>)manager;

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

-(UIViewController *)enrollUILoadWithService:(id<ITransport>)service withCaptureManager:(id<IOPCRCaptureManager>)manager{
    return [self loadStoriboard:@"Enroll" withService:service withCaptureManager:manager];
}

-(UIViewController *)verifyUILoadWithService:(id<ITransport>) service withCaptureManager:(id<IOPCRCaptureManager>)manager{
    return [self loadStoriboard:@"Verify" withService:service withCaptureManager:manager];
}


@end

@implementation OPUILoader(PrivateMethods)

-(UIViewController *)loadStoriboard:(NSString *)storiboardName
                        withService:(id<ITransport>)service
                 withCaptureManager:(id<IOPCRCaptureManager>)manager{
    NSBundle *frameworkBundle = [NSBundle bundleForClass:[self class]];
    UIViewController *vc = [[UIStoryboard storyboardWithName:storiboardName bundle: frameworkBundle] instantiateInitialViewController];
    if([vc conformsToProtocol:@protocol(ITransportService)]){
        id<ITransportService> vcService = (id<ITransportService>)vc;
        [vcService setService:service ];
    }
    if([vc conformsToProtocol:@protocol(IsIOPCRCaptureManager)]){
        id<IsIOPCRCaptureManager> vcManager = (id<IsIOPCRCaptureManager>)vc;
        [vcManager setCaptureManager:manager];
    }
    return vc;
}

@end

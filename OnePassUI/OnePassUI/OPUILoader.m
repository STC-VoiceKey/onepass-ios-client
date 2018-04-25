 //
//  STCUILoader.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 14.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPUILoader.h"
#import <OnePassCore/OnePassCore.h>
#import <OnePassCapture/OnePassCapture.h>
#import "OPUIModalitiesManager.h"

@interface OPUILoader()

/**
 Is the enrollment 'ResultBlock'
 */
@property (nonatomic) ResultBlock enrollResultBlock;

/**
 Is the verification 'ResultBlock'
 */
@property (nonatomic) ResultBlock verifyResultBlock;


@end

@interface OPUILoader(PrivateMethods)

/**
 Loads the initial view controller from the storyboard and presets the transport service and the capture manager

 @param storyboardName The storyboard name
 @param service The 'IOPCTransportProtocol' implementation
 @param manager The 'IOPCCaptureManagerProtocol' implementation
 @return The initial view controller of the storyboard
 */
-(UIViewController *)loadStoryboard:(NSString *)storyboardName
                        withService:(id<IOPCTransportProtocol>)service
                 withCaptureManager:(id<IOPCCaptureManagerProtocol>)manager;

-(NSString *)verificationStoryboardName;

@end

@implementation OPUILoader

+ (id<IOPUILoaderProtocol>)sharedInstance{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(UIViewController *)enrollUILoadWithService:(id<IOPCTransportProtocol>)service
                          withCaptureManager:(id<IOPCCaptureManagerProtocol>)manager{
    NSString *storyboardName = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) ? @"Enroll_iPad" : @"Enroll_iPhone";
    return [self loadStoryboard:storyboardName withService:service withCaptureManager:manager];
}

-(UIViewController *)verifyUILoadWithService:(id<IOPCTransportProtocol>) service withCaptureManager:(id<IOPCCaptureManagerProtocol>)manager{
   return [self loadStoryboard:self.verificationStoryboardName withService:service withCaptureManager:manager];
}

@end

@implementation OPUILoader(PrivateMethods)

-(UIViewController *)loadStoryboard:(NSString *)storyboardName
                        withService:(id<IOPCTransportProtocol>)service
                 withCaptureManager:(id<IOPCCaptureManagerProtocol>)manager{
    
    NSBundle *frameworkBundle = [NSBundle bundleForClass:[self class]];
    UIViewController *vc = [[UIStoryboard storyboardWithName:storyboardName bundle:frameworkBundle] instantiateInitialViewController];
    
    if([vc conformsToProtocol:@protocol(IOPCTransportableProtocol)]){
        id<IOPCTransportableProtocol> vcService = (id<IOPCTransportableProtocol>)vc;
        [vcService setService:service ];
    }
    
    if([vc conformsToProtocol:@protocol(IOPCIsCaptureManagerProtocol)]){
        id<IOPCIsCaptureManagerProtocol> vcManager = (id<IOPCIsCaptureManagerProtocol>)vc;
        [vcManager setCaptureManager:manager];
    }
    
    return vc;
}

-(NSString *)verificationStoryboardName{
    
    id<IOPUIModalitiesManagerProtocol> modalityManager = [[OPUIModalitiesManager alloc] init];;
    
    NSString *storyboardName;
    
    switch (modalityManager.modalityState) {
        case OPUIModalitiesStateFaceOnly:
            storyboardName = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) ? @"VerifyFace_iPad" : @"VerifyFace_iPhone";
            break;
            
        case OPUIModalitiesStateVoiceOnly:
            storyboardName = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) ? @"VerifyVoice_iPad" : @"VerifyVoice_iPhone";
            break;
            
        case OPUIModalitiesStateWithOutLiveness:
            storyboardName = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) ? @"VerifyFaceAndVoice_iPad" : @"VerifyFaceAndVoice_iPhone";
            break;
            
        default:
            storyboardName = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) ? @"Verify_iPad" : @"Verify_iPhone";
            break;

    }
    return storyboardName;
}

@end

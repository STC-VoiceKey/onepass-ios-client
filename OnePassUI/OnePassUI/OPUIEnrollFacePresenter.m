//
//  OPUIEnrollFaceCapturePresenter.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 10.11.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import "OPUIEnrollFacePresenter.h"
#import "OPUIModalitiesManager.h"
#import "OPUILoader.h"

#import "OPUIEnrollFaceViewProtocol.h"

@interface OPUIEnrollFacePresenter()

@property (nonatomic) id<OPUIEnrollFaceViewProtocol> view;

/**
 The photo capture manager can implement the extra protocols for the portrait features and environment checking
 */
@property (nonatomic)      id<IOPCCapturePhotoManagerProtocol,
                                 IOPCPortraitFeaturesProtocol,
                                      IOPCEnvironmentProtocol,
                            IOPCInterfaceOrientationProtocol> photoCaptureManager;

@property (nonatomic)      id<IOPCTransportProtocol> service;

@property (nonatomic)      id<IOPUIModalitiesManagerProtocol> modalitiesManager;

@property (nonatomic)      BOOL isFaceCaptured;

@end

@interface OPUIEnrollFacePresenter(Private)

-(void)logDataImage:(NSData *)data;

@end

@implementation OPUIEnrollFacePresenter

-(id)init {
    self = [super init];
    if (self) {
        self.modalitiesManager = [[OPUIModalitiesManager alloc] init];
    }
    return self;
}

- (void)attachView:(id<OPUIEnrollFaceViewProtocol>)view {
    self.view = view;
    [self.view enableCancel];
}

- (void)deattachView {
    self.view = nil;
    [self.photoCaptureManager stopRunning];
    self.photoCaptureManager.loadImageBlock = nil;
    self.photoCaptureManager = nil;
}

- (void)onCancel {
    self.photoCaptureManager.loadImageBlock = nil;
    [self.view exit];
}

-(void)setPhotoCaptureManager:(id<IOPCCapturePhotoManagerProtocol,
                               IOPCPortraitFeaturesProtocol,
                               IOPCEnvironmentProtocol,
                               IOPCInterfaceOrientationProtocol>)photoCaptureManager {
    _photoCaptureManager = photoCaptureManager;
    
    NSLog(@"photoCaptureManager = %@",_photoCaptureManager);
    
    self.isFaceCaptured = NO;
    
    __weak typeof(self) weakself = self;
    
    [self.photoCaptureManager setLoadImageBlock:^(CIImage *image, NSError *error) {
        NSLog(@"setLoadImageBlock");
        
        [weakself.view disableCancel];
        
        if (error) {
            [weakself.view showError:error];
            return ;
        }
        
        if (weakself.isFaceCaptured) {
            return;
        }
        
        [weakself.view showActivity];
        
        NSData *data = [weakself.view dataFromCIImage:image];
        
        if( data==nil ) {
            return;
        }
        
        [weakself logDataImage:data];
         weakself.isFaceCaptured = YES;

        [weakself.service addFaceSample:data
                    withCompletionBlock:^(NSDictionary *responceObject, NSError *error) {
                        if (error) {
                            [weakself.view showError:error];
                            return;
                        }
                        
                        if (weakself.modalitiesManager.isVoiceOn) {
                            [weakself.view routeToVoicePage];
                        } else {
                            if (weakself.modalitiesManager.isStaticVoiceOn) {
                                [weakself.view routeToStaticVoicePage];
                            } else {
                                [OPUILoader.sharedInstance enrollResultBlock](YES,nil);
                            }
                        }
                        [weakself.view hideActivity];
                        [weakself.view enableCancel];
                    }];
    }];
    
}

-(void)setPreviewView:(id<IOPCPreviewView>)preview {
    [self.photoCaptureManager setPreview:preview];
    [self.photoCaptureManager startRunning];
}

-(void)didOrientationChanged:(OPCAvailableOrientation)currentOrientation {
    [self.photoCaptureManager setInterfaceOrientation:currentOrientation];
}

-(void)didStable{
    if (self.photoCaptureManager.isRunning) {
        [self.view showActivity];
        [self.photoCaptureManager stopRunning];
        [self.photoCaptureManager takePicture];
    }
}

@end

@implementation OPUIEnrollFacePresenter(Private)

-(void)logDataImage:(NSData *)data {
#ifdef DEBUG
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [NSString stringWithFormat:@"face.jpg"];
    NSString *jpgPath =  [[paths objectAtIndex:0] stringByAppendingPathComponent:path];
    [data writeToFile:jpgPath atomically:YES];
#endif
}
 
@end

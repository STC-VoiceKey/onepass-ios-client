//
//  OPUIVerifyFacePresenter.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 15.11.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import "OPUIVerifyFacePresenter.h"
#import <OnePassCore/OnePassCore.h>
#import <OnePassCapture/OnePassCapture.h>

#import "OPUIVerifyShowFaceHelperTimer.h"
#import "OPUIVerifyFaceService.h"
#import "OPUILoader.h"

static NSString *observeIsSingleFace = @"self.photoCaptureManager.isSingleFace";
static NSString *observeIsFaceFound  = @"self.photoCaptureManager.isFaceFound";
static NSString *observeIsEyesFound  = @"self.photoCaptureManager.isEyesFound";
//static NSString *observeIsBrightness = @"self.photoCaptureManager.isBrightness";
static NSString *observeisNoTremor   = @"self.photoCaptureManager.isNoTremor";

@interface OPUIVerifyFacePresenter()

@property (nonatomic) id<IOPCCapturePhotoManagerProtocol,
                            IOPCPortraitFeaturesProtocol,
                                 IOPCEnvironmentProtocol,
                        IOPCInterfaceOrientationProtocol> photoCaptureManager;

@property (nonatomic) id<OPUIVerifyShowFaceHelperTimerProtocol> showFaceHelperTimer;
@property (nonatomic) id<OPUIVerifyFaceServiceProtocol>         service;

@property (nonatomic) BOOL isListerning;

@end

@interface OPUIVerifyFacePresenter(Private)

-(void)configureCaptureManager;
-(void)configureIndicators;
-(void)configureHelperTimer;

-(void)updateIndicators;

@end

@implementation OPUIVerifyFacePresenter

- (void)attachView:(id<OPUIVerifyFaceViewProtocol>)view { 
    self.view = view;
    
    [self configureCaptureManager];

    self.service = [[OPUIVerifyFaceService alloc] init];
    [self.service attachView:self.view];

    [self configureHelperTimer];

    self.isListerning = YES;

    [self configureIndicators];
    [self updateIndicators];
}

- (void)deattachView {
    self.view = nil;
    
    [self.photoCaptureManager stopRunning];
    
    self.photoCaptureManager.loadImageBlock = nil;
    self.photoCaptureManager = nil;
    
    self.service = nil;
    
    [self removeObserver:self forKeyPath:observeIsEyesFound];
    [self removeObserver:self forKeyPath:observeIsFaceFound];
    [self removeObserver:self forKeyPath:observeIsSingleFace];
//    [self removeObserver:self forKeyPath:observeIsBrightness];
    [self removeObserver:self forKeyPath:observeisNoTremor];
}

- (void)didCancel { 
    [self.view exit];
}

- (void)didOrientationChanged:(OPCAvailableOrientation)currentOrientation {
    [self.photoCaptureManager setInterfaceOrientation:currentOrientation];
}

-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                      context:(void *)context {
    [self updateIndicators];
    
    if (self.isReady && self.isListerning) {
        [self.photoCaptureManager takePicture];
        NSLog(@"OPUIVerifyFacePresenter  takePicture");
    }
}

-(BOOL)isReady {
    return self.photoCaptureManager.isEyesFound
        && self.photoCaptureManager.isFaceFound
        && self.photoCaptureManager.isSingleFace
        && self.photoCaptureManager.isNoTremor;
        //&& self.photoCaptureManager.isBrightness;
}

-(void)processPhoto:(CIImage *)image {
    
    if (!self.isListerning) {
         return;
    }
    
    self.isListerning = NO;
    
    __weak typeof(self) weakself = self;
    [self.view showActivity];
    [self stopPhotoManager];
    
    [self.service verifyPhoto:image
                      withHandler:^(NSDictionary *result, NSError *error) {
                          [weakself.view hideActivity];
                          if (error) {
                              [weakself.view routeToPageWithError:error];
                              return ;
                          }
                          
                          BOOL verified = [result[@"status"] isEqualToString:@"SUCCESS"];
                          
                          [OPUILoader.sharedInstance verifyResultBlock](verified, result);
                          
                      }];
}

-(void)stopPhotoManager {
     [self.photoCaptureManager stopRunning];
}

@end

@implementation OPUIVerifyFacePresenter(Private)

-(void)configureCaptureManager {
    
    self.photoCaptureManager = self.view.photoCaptureManager;
    [self.photoCaptureManager setPreview:self.view.previewView];
    [self.photoCaptureManager startRunning];

    __weak typeof(self) weakself = self;
    [self.photoCaptureManager setLoadImageBlock:^(CIImage *image, NSError *error) {
        if (error) {
            [weakself.view showError:error];
            return ;
        }
        [weakself processPhoto:image];
    }];
    
    [self addObserver:self forKeyPath:observeIsSingleFace options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [self addObserver:self forKeyPath:observeIsFaceFound  options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [self addObserver:self forKeyPath:observeIsEyesFound  options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
//    [self addObserver:self forKeyPath:observeIsBrightness options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [self addObserver:self forKeyPath:observeisNoTremor   options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

-(void)configureHelperTimer{
    __weak typeof(self) weakself = self;
    self.showFaceHelperTimer = [[OPUIVerifyShowFaceHelperTimer alloc] initWithHandler:^{
        if ( !weakself.photoCaptureManager.isFaceFound ){
            [weakself.view showFacePositionHelper];
        }
    }];
    [self.showFaceHelperTimer start];
}

-(void)configureIndicators {
    [self.view offShackingIndicator];
    [self.view offManyFacesIndicator];
    [self.view offPureLightIndicator];
    [self.view offEyesClosedIndicator];
    [self.view offFaceOffCenterIndicator];
}

-(void)updateIndicators {
    if (!self.photoCaptureManager.isFaceFound) {
        [self.view highlightFaceOffCenterIndicator];
        [self.view offManyFacesIndicator];
        [self.view offShackingIndicator];
        [self.view offEyesClosedIndicator];

        if(!self.showFaceHelperTimer.isProcessing) {
            [self.showFaceHelperTimer start];
        }
    } else {
        [self updateManyFacesIndicator];
        [self updateEyesClosedIndicator];
        [self updateShackingIndicator];
        
        if (self.showFaceHelperTimer.isProcessing) {
            [self.view hideFacePositionHelper];
            [self.showFaceHelperTimer stop];
        }
        
        [self.showFaceHelperTimer stop];
        [self.view offFaceOffCenterIndicator];
    }
    
 //   [self updateBrightness];
}


-(void)updateManyFacesIndicator {
    if (self.photoCaptureManager.isSingleFace) {
        [self.view offManyFacesIndicator];
    } else {
         [self.view highlightManyFacesIndicator];
    }
}

-(void)updateEyesClosedIndicator {
    if (self.photoCaptureManager.isEyesFound) {
        [self.view offEyesClosedIndicator];
    } else {
        [self.view highlightEyesClosedIndicator];
    }
}

-(void)updateShackingIndicator {
    if (self.photoCaptureManager.isNoTremor) {
        [self.view offShackingIndicator];
    } else {
        [self.view highlightShackingIndicator];
    }
}

//-(void)updateBrightness{
//    if (self.photoCaptureManager.isBrightness) {
//        [self.view offPureLightIndicator];
//    } else {
//        [self.view highlightPureLightIndicator];
//    }
//}

@end

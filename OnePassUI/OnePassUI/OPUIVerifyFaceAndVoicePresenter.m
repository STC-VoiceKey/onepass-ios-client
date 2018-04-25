//
//  OPUIVerifyFaceAndVoicePresenter.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 23.11.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import "OPUIVerifyFaceAndVoicePresenter.h"
#import "OPUIVerifyShowFaceHelperTimer.h"
#import "OPUIPassphraseManager.h"

#import <OnePassCore/OnePassCore.h>
#import <OnePassCapture/OnePassCapture.h>

#import "OPUIVerifyFaceAndVoiceViewProtocol.h"
#import "OPUIVerifyFaceAndVoiceServiceProtocol.h"
#import "OPUIVerifyFaceAndVoiceService.h"
#import "OPUIVerifyLimitTimer.h"

#import "OPUILoader.h"

static NSString *observeIsSingleFace = @"self.faceManager.isSingleFace";
static NSString *observeIsFaceFound  = @"self.faceManager.isFaceFound";
static NSString *observeIsEyesFound  = @"self.faceManager.isEyesFound";
//static NSString *observeIsBrightness = @"self.faceManager.isBrightness";
static NSString *observeNoiseValue   = @"self.voiceManager.isNoNoisy";

@interface OPUIVerifyFaceAndVoicePresenter()

@property (nonatomic) id<OPUIVerifyFaceAndVoiceViewProtocol>     view;
@property (nonatomic) id<OPUIVerifyFaceAndVoiceServiceProtocol>  service;

@property (nonatomic) id<IOPCCaptureVoiceManagerProtocol>  voiceManager;
@property (nonatomic) id<IOPCNoisyProtocol>                noiseAnalyzer;
@property (nonatomic) id<IOPCCapturePhotoManagerProtocol,
                            IOPCPortraitFeaturesProtocol,
                                 IOPCEnvironmentProtocol,
                        IOPCInterfaceOrientationProtocol> faceManager;

@property (nonatomic) id<OPUIVoiceLimitTimerProtocol>      timer;
@property (nonatomic) id<OPUIVerifyShowFaceHelperTimerProtocol> showFaceHelperTimer;

@property (nonatomic) CIImage *ciImage;

@property (nonatomic) id<IOPUIPassphraseManagerProtocol> passphraseManager;

@property (nonatomic) BOOL isPhotoCaptured;

@end

@interface OPUIVerifyFaceAndVoicePresenter(Private)

-(void)configureFaceManager;
-(void)configureVoiceManager;
-(void)configureIndicators;
-(void)configureHelperTimer;
-(void)configureFaceAndVoiceService;
-(void)configureTimer;

-(void)updateIndicators;

-(void)addObserving;
-(void)removeObserving;

-(void)startRecord;
-(void)stopRecord;

-(BOOL)isReady;

@end

@implementation OPUIVerifyFaceAndVoicePresenter

- (void)attachView:(id<OPUIVerifyFaceAndVoiceViewProtocol>)view {
    self.view = view;

    self.passphraseManager = [[OPUIPassphraseManager alloc] init];
    
    [self configureFaceManager];
    [self configureVoiceManager];
    [self configureFaceAndVoiceService];
    [self configureTimer];
    
    [self.view hideDigits];
    [self.view showIndicators];
    [self.view hideActivity];

    [self.faceManager startRunning];
    
    self.isPhotoCaptured = NO;
    [self addObserving];
}

- (void)deattachView {
    [self.faceManager stopRunning];
    self.faceManager.loadImageBlock = nil;
    self.faceManager = nil;
    self.view = nil;
    [self removeObserving];
}

- (void)didCancel {
    if (self.voiceManager.isRecording) {
        [self stopRecord];
    }
    [self.view exit];
}

- (void)didOrientationChanged:(OPCAvailableOrientation)currentOrientation { 
    [self.faceManager setInterfaceOrientation:currentOrientation];
}

- (void)processVoice:(NSData *)data {
        __weak typeof(self) weakself = self;
    [self.service verifyPhoto:self.ciImage
                     andVoice:data
                  withHandler:^(NSDictionary *result, NSError *error) {
                      if (error) {
                          [weakself.view routeToPageWithError:error];
                          return ;
                      }
                      BOOL verified = [result[@"status"] isEqualToString:@"SUCCESS"];
                      [OPUILoader.sharedInstance verifyResultBlock](verified, result);
                  }];
}


-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                      context:(void *)context {
    [self updateIndicators];
    
    if (self.isReady) {
        [self.faceManager takePicture];
    }
}

@end

@implementation OPUIVerifyFaceAndVoicePresenter(Private)

-(void)configureFaceManager {
    self.faceManager = self.view.photoCaptureManager;
    [self.faceManager setPreview:self.view.previewView];
    
    __weak typeof(self) weakself = self;
    [self.faceManager setLoadImageBlock:^(CIImage *image, NSError *error) {
        if (weakself.isPhotoCaptured) {
            return ;
        }
        
        if (error) {
            [weakself.view showError:error];
            return ;
        }
        weakself.ciImage = image;
        weakself.isPhotoCaptured = YES;
        [weakself startRecord];
#warning Сделать фотоманагер для предоставления имиджа
    }];
    
    
    [self configureHelperTimer];
}

-(void)configureVoiceManager {
    self.voiceManager = self.view.voiceManager;
    
    [self congigureVoiceManagerAsNoisyAnalyzer];
    
    __weak typeof(self) weakself = self;
    [self.voiceManager setLoadDataBlock:^(NSData *data, NSError *error) {
        [weakself.view showActivity];
        [weakself.faceManager stopRunning];
        [weakself.timer stop];
        [weakself.view showProgress:0];
        
        if( error ) {
            [weakself.view showError:error];
            return ;
        }
        
        [weakself processVoice:data];
    }];
}

-(void)congigureVoiceManagerAsNoisyAnalyzer {
        if([self.voiceManager conformsToProtocol:@protocol(IOPCNoisyProtocol)]) {
        
        [self.view hideNoiseIndicator];
        
        self.noiseAnalyzer = (id<IOPCNoisyProtocol>)self.voiceManager;
        [self.noiseAnalyzer startNoiseAnalyzer];
    }
}

-(void)configureFaceAndVoiceService {
    self.service = [[OPUIVerifyFaceAndVoiceService alloc] initWithService:self.view.service];
    [self.service startSessionForUser:self.view.user
                          withHandler:^(NSDictionary *result, NSError *error) {
                              
                              NSString *convertedDigits = [self.passphraseManager convertToDigits:result[@"passphrase"]];
                              if (convertedDigits != nil && convertedDigits.length != 0) {
                                  [self.view configureDigits:convertedDigits];
                              } else {
                                  NSError *langError = [NSError errorWithDomain:@"com.speachpro.onepass"
                                                                           code:400
                                                                       userInfo:@{ NSLocalizedDescriptionKey: @"Languages do not match"}];
                                  [self.view showAlertError:langError];
                                  [self.view configureDigits:result[@"passphrase"]];
                              }
                          }];
}


-(void)configureTimeProgress{
    [self.view showProgress:0];
}

-(void)configureTimer {
    self.timer = [[OPUIVerifyLimitTimer alloc] initWithView:self.view
                                          withHandler:^{
                                                [self stopRecord];
                                        }];
}

-(void)configureHelperTimer{
    __weak typeof(self) weakself = self;
    self.showFaceHelperTimer = [[OPUIVerifyShowFaceHelperTimer alloc] initWithHandler:^{
        if ( !weakself.faceManager.isFaceFound ) {
            [weakself.view showFacePositionHelper];
        }
    }];
    [self.showFaceHelperTimer start];
}

-(void)configureIndicators {
    [self.view offManyFacesIndicator];
    [self.view offPureLightIndicator];
    [self.view offEyesClosedIndicator];
    [self.view offFaceOffCenterIndicator];
    [self.view hideNoiseIndicator];
}

-(void)updateIndicators {
    if (!self.faceManager.isFaceFound) {
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
        
        if (self.showFaceHelperTimer.isProcessing) {
            [self.view hideFacePositionHelper];
            [self.showFaceHelperTimer stop];
        }
        
        [self.view offFaceOffCenterIndicator];
    }
    
    [self updateBrightness];
    [self updateNoisyIndicator];
}

-(void)updateManyFacesIndicator {
    if (self.faceManager.isSingleFace) {
        [self.view offManyFacesIndicator];
    } else {
        [self.view highlightManyFacesIndicator];
    }
}

-(void)updateEyesClosedIndicator {
    if (self.faceManager.isEyesFound) {
        [self.view offEyesClosedIndicator];
    } else {
        [self.view highlightEyesClosedIndicator];
    }
}

-(void)updateBrightness{
    //if (self.faceManager.isBrightness) {
        [self.view offPureLightIndicator];
//    } else {
//        [self.view highlightPureLightIndicator];
//    }
}

-(void)updateNoisyIndicator {
    if (self.noiseAnalyzer.isNoNoisy) {
        [self.view hideNoiseIndicator];
    } else {
        [self.view showNoiseIndicator];
    }
}

-(BOOL)isReady {
    return self.faceManager.isEyesFound
    && self.faceManager.isFaceFound
    && self.faceManager.isSingleFace
    && self.noiseAnalyzer.isNoNoisy;
    //&& self.faceManager.isBrightness;
}

-(void)startRecord {
    if (!self.voiceManager.isRecording) {
        [self.view showDigits];
        [self.view hideIndicators];
        
        [self.view hideFacePositionHelper];
        [self.showFaceHelperTimer stop];
        [self.timer start];
        
        if (self.noiseAnalyzer) {
            [self.noiseAnalyzer stopNoiseAnalyzer];
        }
        
        [self.voiceManager record];
    }
}

-(void)stopRecord {
    if (self.voiceManager.isRecording) {
        [self.voiceManager stop];
        [self.timer stop];
    }
}

-(void)addObserving {
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld;
    
    [self addObserver:self forKeyPath:observeIsSingleFace options:options context:nil];
    [self addObserver:self forKeyPath:observeIsFaceFound  options:options context:nil];
    [self addObserver:self forKeyPath:observeIsEyesFound  options:options context:nil];
  //  [self addObserver:self forKeyPath:observeIsBrightness options:options context:nil];
    
    [self addObserver:self forKeyPath:observeNoiseValue options:options context:nil];
}

-(void)removeObserving {
    [self removeObserver:self forKeyPath:observeIsSingleFace];
    [self removeObserver:self forKeyPath:observeIsFaceFound];
    [self removeObserver:self forKeyPath:observeIsEyesFound];
 //   [self removeObserver:self forKeyPath:observeIsBrightness];
    
    [self removeObserver:self forKeyPath:observeNoiseValue];
}

@end

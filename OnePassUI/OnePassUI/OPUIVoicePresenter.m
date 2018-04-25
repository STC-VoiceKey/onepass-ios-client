//
//  OPUIEnrollVoicePresenter.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 10.11.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import "OPUIVoicePresenter.h"
#import "OPUIBlockCentisecondsTimer.h"
#import "OPUILoader.h"
#import "OPUILimitTimer.h"
#import "OPUIEnrollVoiceService.h"

#import <OnePassCore/OnePassCore.h>

#import <OnePassCapture/OnePassCapture.h>


#pragma mark - Observation Fields
static NSString *observeNoiseValue   = @"self.voiceManager.isNoNoisy";

@interface OPUIVoicePresenter()

/**
 The manager which provides information about the noise enviroment
 */
@property (nonatomic, strong) id<IOPCNoisyProtocol>                noiseAnalyzer;
/**
 The manager which displays voice wave
 */
@property (nonatomic, weak)   id<IOPCIsVoiceVisualizerProtocol>    voiceVisualizer;

@property (nonatomic) id<OPUIVoiceLimitTimerProtocol> timer;

@end

@interface OPUIVoicePresenter(Private)

-(void)configureVoiceManager;
-(void)configureTimeProgress;
-(void)configureTimer;

@end

@implementation OPUIVoicePresenter

-(id)initWith:(id<IOPCCaptureVoiceManagerProtocol>)voiceManager
  withService:(id<IOPCTransportProtocol>)service {
    self = [super init];
    if (self) {
        self.service = [[OPUIEnrollVoiceService alloc] init];
        [self.service setService:service];
        self.voiceManager = voiceManager;
    }
    return self;
}

- (void)attachView:(id<OPUIVoiceViewProtocol>)view {
    self.view = view;
    [self.view showStartState];
    
    [self configureTimeProgress];
    [self configureTimer];
    
    [self configureVoiceManager];
}

- (void)deattachView {
    if([self.voiceManager isRecording]) {
        [self.voiceManager stop];
    } else {
        if (self.noiseAnalyzer) {
            [self removeObserver:self forKeyPath:observeNoiseValue];
            
            [self.noiseAnalyzer stopNoiseAnalyzer];
            self.noiseAnalyzer = nil;
        }
    }
    self.view = nil;
}

-(void)dealloc{
    if(_noiseAnalyzer) {
        [self removeObserver:self forKeyPath:observeNoiseValue];
    }
}

- (void)didCancelAction {
    if([self.voiceManager isRecording]) {
        [self.voiceManager setLoadDataBlock:nil];
        [self stopRecord];
    }
    [self.view exit];
}

- (void)onAction { 
    if (self.voiceManager.isRecording) {
        [self stopRecord];
    } else {
        [self startRecord];
    }
}

- (void)processVoice:(NSData *)data {
}


- (void)processVoice {
}


- (void)startRecord {
    [self.view showStopState];
    
    if (self.noiseAnalyzer) {
        [self.noiseAnalyzer stopNoiseAnalyzer];
    }
    
    [self.view showWaveView];
    
    [self.voiceManager record];
    [self.timer start];
}

- (void)stopRecord {
    [self.voiceManager stop];
    [self.view showStartState];
    [self.view hideWaveView];
    [self.view showProgress:0];
    [self.timer stop];
}

-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                      context:(void *)context{
    if ([keyPath isEqualToString:observeNoiseValue]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([self.noiseAnalyzer isNoNoisy]) {
                [self.view hideNoiseIndicator];
                [self.view enabledStartButton];
            } else {
                [self.view showNoiseIndicator];
                [self.view disabledStartButton];
            }
        });
    }
}

@end

@implementation OPUIVoicePresenter(Private)

-(void)configureVoiceManager {
    
    [self congigureVoiceManagerAsVoiceVisualizer];
    [self congigureVoiceManagerAsNoisyAnalyzer];
    
    __weak typeof(self) weakself = self;
    [self.voiceManager setLoadDataBlock:^(NSData *data, NSError *error) {
        [weakself.view showActivity];
        [weakself.timer stop];
        [weakself.view showProgress:0];
        
        if( error ) {
            [weakself.view showError:error];
            return ;
        }
        
        [weakself processVoice:data];
    }];
}

-(void)congigureVoiceManagerAsVoiceVisualizer {
    if([self.voiceManager conformsToProtocol:@protocol(IOPCIsVoiceVisualizerProtocol)]) {
        self.voiceVisualizer = (id<IOPCIsVoiceVisualizerProtocol>)self.voiceManager;
        [self.voiceVisualizer setPreview:self.view.visualView];
    }
}

-(void)congigureVoiceManagerAsNoisyAnalyzer {
    if([self.voiceManager conformsToProtocol:@protocol(IOPCNoisyProtocol)]) {
        
        [self addObserver:self
               forKeyPath:observeNoiseValue
                  options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                  context:nil];
        
        [self.view hideNoiseIndicator];
        
        self.noiseAnalyzer = (id<IOPCNoisyProtocol>)self.voiceManager;
        [self.noiseAnalyzer startNoiseAnalyzer];
    }
}

-(void)configureTimeProgress{
    [self.view showProgress:0];
}

-(void)configureTimer {
   self.timer = [[OPUILimitTimer alloc] initWithView:self.view
                                                    withHandler:^{
                                                        [self stopRecord];
                                                    }];
}

-(void)viewTimerDidExpared {
    if(!self.voiceManager.isRecording) {
        [self.view exit];
    }
}

@end

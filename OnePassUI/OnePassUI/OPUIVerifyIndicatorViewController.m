//
//  OPUIVerifyIndicatorViewController.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 27.10.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPUIVerifyIndicatorViewController.h"
#import "OPUIBlockSecondTimer.h"
#import "OPUICorporateColorUtils.h"
#import "OPUIIndicatorImageView.h"

#import <OnePassCapture/OnePassCapture.h>

static NSString *observeNoiseValue   = @"self.frameCaptureManager.isNoNoisy";

@interface OPUIVerifyIndicatorViewController ()

@property (nonatomic, weak) IBOutlet OPUIIndicatorImageView   *bbNoisy;

/**
 Shows that the controller observes the noise enviroment
 */
@property (nonatomic) BOOL isNoisyObserving;

/**
 The manager of the capture verification resources when the liveness features is calculated on device
 */
@property (nonatomic, weak)   id<IOPCLivenessProtocol>  livenessManager;

/**
 The manager which provides information about the noise enviroment
 */
@property (nonatomic, weak)   id<IOPCNoisyProtocol>     noisyManager;

@end

@interface OPUIVerifyIndicatorViewController (PrivateMethods)

/**
 Changes indicators states
 */
-(void)updateIndicators;

@end

@implementation OPUIVerifyIndicatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.isNoisyObserving = NO;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
     if(self.noisyManager) {
         self.bbNoisy.active = self.noisyManager.isNoNoisy;
     }
    
    if([self.frameCaptureManager conformsToProtocol:@protocol(IOPCNoisyProtocol)]) {
        self.noisyManager = (id<IOPCNoisyProtocol>)self.frameCaptureManager;
        
        [self addObserverForKeyPath:observeNoiseValue];
        self.isNoisyObserving = YES;
        
        [self.noisyManager startNoiseAnalyzer];
    }
}

-(BOOL)calcReady{
    return [self.frameCaptureManager isFaceFound]
        && [self.frameCaptureManager isSingleFace]
        //&& [self.frameCaptureManager isBrightness]
        && (self.noisyManager ?  [self.noisyManager isNoNoisy] : YES);
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];

    if (self.isNoisyObserving) {
        [self removeObserver:self forKeyPath:observeNoiseValue];
        self.isNoisyObserving = NO;
    }
    
    self.frameCaptureManager = nil;
}

-(void)dealloc{
    if (_isNoisyObserving) {
        [self removeObserver:self forKeyPath:observeNoiseValue];
        _isNoisyObserving = NO;
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSString *,id> *)change
                      context:(void *)context{
    
    if ([keyPath isEqualToString:observeNoiseValue]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.bbNoisy.active = self.noisyManager.isNoNoisy;
        });
    }
    
    
    
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

@end


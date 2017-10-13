//
//  OPUIIndicatorsViewController.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 08.12.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPUIIndicatorsViewController.h"
#import "OPUIBlockSecondTimer.h"
#import "OPUIWarningView.h"
#import "OPUIIndicatorImageView.h"

static NSString *observeIsSingleFace = @"self.frameCaptureManager.isSingleFace";
static NSString *observeIsFaceFound  = @"self.frameCaptureManager.isFaceFound";
static NSString *observeIsEyesFound  = @"self.frameCaptureManager.isEyesFound";
static NSString *observeIsBrightness = @"self.frameCaptureManager.isBrightness";
static NSString *observeisNoTremor   = @"self.frameCaptureManager.isNoTremor";

@interface OPUIIndicatorsViewController ()

@property (nonatomic, weak) IBOutlet OPUIIndicatorImageView   *imageSingleFace;
@property (nonatomic, weak) IBOutlet OPUIIndicatorImageView   *imageFaceFound;
@property (nonatomic, weak) IBOutlet OPUIIndicatorImageView   *imageEyesFound;
@property (nonatomic, weak) IBOutlet OPUIIndicatorImageView   *imageBrightness;
@property (nonatomic, weak) IBOutlet OPUIIndicatorImageView   *imageTremor;

/**
 The view with the mask to help position the face
 */
@property (nonatomic) OPUIWarningView *maskView;

/**
 Shows that the controller observes something
 */
@property (nonatomic) BOOL isObserving;

/**
 Calculates the value of all observed properties
 */
@property (nonatomic) BOOL isReady;

/**
 Shows that it is necessary to send the result of the observation
 */
@property (nonatomic) BOOL isListerning;

/**
 The timer which checks that the face not detected and calls the positioning mask 
 */
@property (nonatomic) OPUIBlockSecondTimer  *faceNoFoundTimer;

///**
// Shows the mask visibility
//
// @return YES, if the face positioning mask is visible
// */
//@property (nonatomic) BOOL isMaskShown;

@property (nonatomic) UIInterfaceOrientation interfaceOrientation;
@end

@interface OPUIIndicatorsViewController (PrivatesMethods)

/**
 Updates the indicator visual state
 */
-(void)updateIndicators;

/**
 Shows the face positioning mask
 */
-(void)showMask;

/**
 Hides the face positioning mask
 */
-(void)hideMask;
-(void)removeMask;

/**
 Is invoked when the device orientation is changed 
 */
-(void)updateOrientation;

#warning docs
-(void)resetIndicators;


@end

@implementation OPUIIndicatorsViewController

-(void)viewDidLoad {
    [super viewDidLoad];

    self.isObserving = NO;
    self.isListerning = NO;
    self.interfaceOrientation = UIApplication.sharedApplication.statusBarOrientation;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self resetIndicators];
    
    if (self.frameCaptureManager){
        self.isReady = NO;
    
        [self updateIndicators];
    
        [self addObserverForKeyPath:observeIsSingleFace];
        [self addObserverForKeyPath:observeIsFaceFound];
        [self addObserverForKeyPath:observeIsEyesFound];
        [self addObserverForKeyPath:observeIsBrightness];
        [self addObserverForKeyPath:observeisNoTremor];
    
        __weak typeof(self) weakself = self;
        self.faceNoFoundTimer = [[OPUIBlockSecondTimer alloc] initTimerWithProgressBlock:nil
                                                                     withResultBlock:^(float secund){
                                     if (![weakself.frameCaptureManager isFaceFound]){
                                         if (!weakself.isReady && weakself.isListerning){
                                             [weakself showMask];
                                         }
                                     }
                                 }];
    
        self.isObserving = YES;
    
        if(self.isReady != [self calcReady]){
            self.isReady = [self calcReady];
            self.readyBlock(self.isReady);
        }
    
        self.isListerning = YES;
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    self.isListerning = NO;
    
    [self removeMask];
    
    if(self.isObserving) {
        [self removeObserver:self forKeyPath:observeIsEyesFound];
        [self removeObserver:self forKeyPath:observeIsFaceFound];
        [self removeObserver:self forKeyPath:observeIsSingleFace];
        [self removeObserver:self forKeyPath:observeIsBrightness];
        [self removeObserver:self forKeyPath:observeisNoTremor];
        
        self.isObserving = NO;
    }
    
    self.frameCaptureManager = nil;
    self.faceNoFoundTimer = nil;
}

-(void)dealloc {
    
    if(_isObserving) {
        [self removeObserver:self forKeyPath:observeIsEyesFound];
        [self removeObserver:self forKeyPath:observeIsFaceFound];
        [self removeObserver:self forKeyPath:observeIsSingleFace];
        [self removeObserver:self forKeyPath:observeIsBrightness];
        [self removeObserver:self forKeyPath:observeisNoTremor];
        
        _isObserving = NO;
    }
    
    _frameCaptureManager = nil;
}

-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSString *,id> *)change
                      context:(void *)context {
    if(!self.isListerning) {
        return;
    }
    
    [self updateIndicators];
    
    if(self.isReady!=[self calcReady]) {
        self.isReady = [self calcReady];
        self.readyBlock(self.isReady);
    }
}

-(ReadyBlock)readyBlock{
    if (_readyBlock) {
        return _readyBlock;
    } else {
        return ^(BOOL isReady){};
    }
}

-(BOOL)calcReady{
    return [self.frameCaptureManager isEyesFound]
        && [self.frameCaptureManager isFaceFound]
        && [self.frameCaptureManager isSingleFace]
        && [self.frameCaptureManager isNoTremor]
        && [self.frameCaptureManager isBrightness];
}

-(void)stopObserving {
    [self resetIndicators];
    
    self.isListerning = NO;
}

@end

@implementation OPUIIndicatorsViewController (PrivatesMethods)

-(void)resetIndicators{
    self.imageSingleFace.active = NO;
    self.imageTremor.active     = NO;
    self.imageEyesFound.active  = NO;
    self.imageFaceFound.active  = NO;
    self.imageBrightness.active = NO;
}

-(void)updateIndicators {
    if (!self.frameCaptureManager.isFaceFound) {
        self.imageFaceFound.active = YES;
        
        self.imageSingleFace.active = NO;
        self.imageTremor.active     = NO;
        self.imageEyesFound.active  = NO;
        
        if(![self.faceNoFoundTimer isProcessing]) {
            [self.faceNoFoundTimer startWithTime:2];
        }
        
    } else {
        [self.faceNoFoundTimer stop];
       
        [self hideMask];
        
        self.imageFaceFound.active = NO;
        
        self.imageSingleFace.active = !self.frameCaptureManager.isSingleFace;
        self.imageEyesFound.active  = !self.frameCaptureManager.isEyesFound;
        self.imageTremor.active     = !self.frameCaptureManager.isNoTremor;
    }
    
    self.imageBrightness.active = ![self.frameCaptureManager isBrightness];
}

-(BOOL)isMaskShown{
    if ( (self.maskView!=nil) && (self.maskView.alpha!=0) ) {
        return YES;
    }
    return NO;
}
-(void)showMask{
    if(self.isMaskShown) {
        return;
    }
    
    if (self.maskView == nil ) {
        [self addMask];
    }
    self.maskView.alpha = 0;
    [UIView animateWithDuration:0.5f
                     animations:^{
                         [self.maskView setAlpha:1.0f];
                     } completion:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(updateOrientation)
                                               name:UIDeviceOrientationDidChangeNotification
                                             object:nil];
}

-(void)hideMask{
    if(!self.isMaskShown) {
        return;
    }


                             dispatch_async(dispatch_get_main_queue(), ^{
                                 self.maskView.alpha = 0.0f;
                             });
    
    [NSNotificationCenter.defaultCenter removeObserver:self
                                                  name:UIDeviceOrientationDidChangeNotification
                                                object:nil];
}

-(void)addMask {
    NSLog(@"add mask");
    NSBundle *currentBundle = [NSBundle bundleForClass:[self class]];
    NSArray *nib = [currentBundle loadNibNamed:@"OPUIFaceNotFoundView" owner:self options:nil];
    self.maskView = (OPUIWarningView *)[nib objectAtIndex:0];
    self.maskView.frame = self.viewMaskContainer.bounds;
    self.maskView.warning = NSLocalizedStringFromTableInBundle(@"Face off-center", @"OnePassUILocalizable", currentBundle, nil);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.viewMaskContainer addSubview:self.maskView];
    });
    
    self.maskView.alpha = 0;

}

-(void)removeMask {
    NSLog(@"remove mask");
    [self hideMask];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.maskView removeFromSuperview];
        self.maskView = nil;
    });
}

-(void)updateOrientation{

    UIInterfaceOrientation currentOrientation = UIApplication.sharedApplication.statusBarOrientation;
    
    if(currentOrientation == self.interfaceOrientation) {
        return;
    }
    self.interfaceOrientation = currentOrientation;
    
    if (self.isMaskShown) {
        [self removeMask];
   //     [self addMask];
//        [self showMask];
    }
}

@end

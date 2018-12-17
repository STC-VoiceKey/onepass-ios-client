
//
//  OPUIEnrollFaceCaptureViewController..m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 14.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPUIEnrollFaceViewController.h"

#import <OnePassCore/OnePassCore.h>
#import <OnePassCapture/OnePassCapture.h>

#import "OPUIIndicatorsViewController.h"
#import "UIActivityIndicatorView+Status.h"
#import "OPUIBlockCentisecondsTimer.h"
#import "OPCRPreviewView.h"

#import "OPUIEnrollFacePresenterProtocol.h"
#import "OPUIEnrollFacePresenter.h"

#import "OPUIBlockSecondTimer.h"

static NSString *kVoiceSegueIdentifier = @"kVoiceSegueIdentifier";
static NSString *kStaticVoiceFromFaceSegueIdentifier = @"kStaticVoiceFromFaceSegueIdentifier";
static NSString *kExitPhotoSegueIdentifier    = @"kExitPhotoSegueIdentifier";
static NSString *kIndicatorSegueIdentifier    = @"kIndicatorSegueIdentifier";

@interface OPUIEnrollFaceViewController ()

/**
 The view controller manages the positioning face indicators
 */
@property (nonatomic, weak) OPUIIndicatorsViewController *indicatorViewController;

/**
 The view displays the video stream
 */
@property (nonatomic, weak) IBOutlet OPCRPreviewView   *viewFaceCapture;

/**
 The view where the the warning view is added
 */
@property (nonatomic, weak) IBOutlet UIView            *viewMaskContainer;

@property (nonatomic, weak) IBOutlet UIButton *cancelButton;

/**
 Shows that the checking stable timer is running
 */
@property (nonatomic) BOOL isTimering;

/**
 Shows the face picture is stable and the photo can be taken
 */
@property (nonatomic) BOOL isStable;

@property (nonatomic) OPUIBlockSecondTimer       *stabilizationTimer;

@property (nonatomic) id<OPUIEnrollFacePresenterProtocol> presenter;

@end

@interface OPUIEnrollFaceViewController(PrivateMethods)

/**
 Converts image from CIImage to UIImage

 @param ciImage The source image
 @return The converted image
 */
-(UIImage *)imageCI2UI:(CIImage *)ciImage;

-(void)initStabilizationTimer;
-(void)initIndicatorReadyBlock;

@end

@implementation OPUIEnrollFaceViewController

#pragma mark - Lifecircle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.presenter = [[OPUIEnrollFacePresenter alloc] init];

    self.isTimering = NO;
    [self updateOrientation];
}

-(void)applicationDidEnterBackground{
    [self exit];
}

-(void)networkStateChanged:(BOOL)isHostAccessable{
    if (!isHostAccessable) {
        [self exit];
    }
}

-(void)viewTimerDidExpared{
    [self exit];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.presenter attachView:self];
    [self.presenter setPhotoCaptureManager:self.captureManager.photoManager];
    [self.presenter setPreviewView:self.viewFaceCapture];
    [self.presenter setService:self.service];

    if(self.indicatorViewController) {
        self.indicatorViewController.frameCaptureManager = self.captureManager.photoManager;
        self.indicatorViewController.viewMaskContainer   = self.viewMaskContainer;
    }

   [self.presenter didOrientationChanged:self.currentOrientation];
    
    self.stabilizationTimer = nil;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self initIndicatorReadyBlock];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [self.presenter deattachView];
    
    if(self.indicatorViewController) {
        self.indicatorViewController.viewMaskContainer = nil;
    }

    [self stopActivityAnimating];
    self.indicatorViewController.readyBlock = nil;
}

-(void)updateOrientation{
    [super updateOrientation];
    
    [self.presenter didOrientationChanged:self.currentOrientation];
}

-(void)dealloc{
    _indicatorViewController.frameCaptureManager = nil;
    _indicatorViewController.readyBlock = nil;
    _indicatorViewController = nil;
}

#pragma mark - Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:kIndicatorSegueIdentifier]) {
        if(self.indicatorViewController){
            self.indicatorViewController.readyBlock = nil;
        }
        
        self.indicatorViewController = (OPUIIndicatorsViewController *)segue.destinationViewController;
    }
}

- (IBAction)unwindTryAgain:(UIStoryboardSegue *)unwindSegue{
}

-(IBAction)onCancel:(id)sender{
    [self.presenter onCancel];
}

#pragma mark - OPUIEnrollFaceCaptureViewProtocol

-(void)showError:(NSError *)error{
    if([error.domain isEqualToString:NSURLErrorDomain]) {
        [self performSegueOnMainThreadWithIdentifier:kExitPhotoSegueIdentifier];
    } else {
        if(error) {
            [self showError:error withTitle:@"Give it another shot"];
        } else {
            [self performSegueOnMainThreadWithIdentifier:kVoiceSegueIdentifier];
        }
    }
}

-(void)exit {
    [self performSegueOnMainThreadWithIdentifier:kExitPhotoSegueIdentifier];
}

-(NSData *)dataFromCIImage:(CIImage *)ciImage{
    UIImage *uiImage = [self imageCI2UI:ciImage];
    return  UIImageJPEGRepresentation(uiImage, 0.9);
}

-(void)showActivity {
    [self startActivityAnimating];
}

-(void)hideActivity {
    [self stopActivityAnimating];
}

-(void)stopIndicatorObserving {
    [self.indicatorViewController stopObserving];
}

- (void)routeToVoicePage {
    [self performSegueOnMainThreadWithIdentifier:kVoiceSegueIdentifier];
}

-(void)routeToStaticVoicePage{
    [self performSegueOnMainThreadWithIdentifier:kStaticVoiceFromFaceSegueIdentifier];
}

-(void)disableCancel{
    self.cancelButton.enabled = NO;
}

-(void)enableCancel{
    self.cancelButton.enabled = YES;
}

@end

@implementation OPUIEnrollFaceViewController(PrivateMethods)

-(UIImage *)imageCI2UI:(CIImage *)ciImage{
    CIContext *ciContext = [CIContext contextWithOptions:nil];
    CGImageRef cgImageRef = [ciContext createCGImage:ciImage fromRect:ciImage.extent];
    
    UIImage *nsImage = [UIImage imageWithCGImage:cgImageRef];
    
    CGImageRelease(cgImageRef);
    return nsImage;
}

-(void)initStabilizationTimer{
    __weak typeof(self) weakself = self;
    weakself.stabilizationTimer = [[OPUIBlockSecondTimer alloc] initTimerWithProgressBlock:nil
                                                                           withResultBlock:^(float seconds) {
                                                                               [weakself.presenter didStable];
                                                                           }];
}

-(void)initIndicatorReadyBlock{
    __weak typeof(self) weakself = self;
    self.indicatorViewController.readyBlock = ^(BOOL isReady){
        if(![weakself.activityIndicator isAnimating]) {
            if (isReady) {
                if (![weakself.stabilizationTimer isProcessing]) {
                    if (!weakself.stabilizationTimer) {
                        [weakself initStabilizationTimer];
                    }
                    [weakself.stabilizationTimer startWithTime:2];
                }
            } else {
                if ([weakself.stabilizationTimer isProcessing]) {
                    [weakself.stabilizationTimer stop];
                }
            }
        }
    };
}

@end


//
//  OPUIEnrollFaceCaptureViewController..m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 14.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPUIEnrollFaceCaptureViewController.h"

#import <OnePassCore/OnePassCore.h>
#import <OnePassCapture/OnePassCapture.h>

#import "OPUIIndicatorsViewController.h"
#import "UIActivityIndicatorView+Status.h"
#import "OPUIBlockCentisecondsTimer.h"
#import "OPCRPreviewView.h"

static NSString *kPhotoSuccessSegueIdentifier = @"kPhotoSuccessSegueIdentifier";
static NSString *kExitPhotoSegueIdentifier    = @"kExitPhotoSegueIdentifier";
static NSString *kIndicatorSegueIdentifier    = @"kIndicatorSegueIdentifier";

@interface OPUIEnrollFaceCaptureViewController ()

/**
 The view controller manages the positioning face indicators
 */
@property (nonatomic, weak) OPUIIndicatorsViewController *indicatorViewController;

/**
 The photo capture manager can implement the extra protocols for the portrait features and environment checking
 */
@property (nonatomic)      id<IOPCCapturePhotoManagerProtocol,
                                 IOPCPortraitFeaturesProtocol,
                                      IOPCEnvironmentProtocol,
                                IOPCInterfaceOrientationProtocol> photoCaptureManager;

/**
 The view displays the video stream
 */
@property (nonatomic, weak) IBOutlet OPCRPreviewView   *viewFaceCapture;

/**
 The view where the the warning view is added
 */
@property (nonatomic, weak) IBOutlet UIView            *viewMaskContainer;

/**
 Shows that the checking stable timer is running
 */
@property (nonatomic) BOOL isTimering;

/**
 Shows the face picture is stable and the photo can be taken
 */
@property (nonatomic) BOOL isStable;

@end

@interface OPUIEnrollFaceCaptureViewController(PrivateMethods)

/**
 Shows the error view controller

 @param error The error
 */
-(void)showError:(NSError *)error;

#warning docs
-(UIImage *)imageCI2UI:(CIImage *)ciImage;

@end

@implementation OPUIEnrollFaceCaptureViewController

#pragma mark - Lifecircle
- (void)viewDidLoad {
    [super viewDidLoad];

    self.isTimering = NO;
    
    [self updateOrientation];
}


-(void)applicationDidEnterBackground{
    [self performSegueWithIdentifier:kExitPhotoSegueIdentifier sender:self];
}

-(void)networkStateChanged:(BOOL)isHostAccessable{
    if (!isHostAccessable) {
        [self performSegueWithIdentifier:kExitPhotoSegueIdentifier sender:self];
    }
}

-(void)viewTimerDidExpared{
    [self performSegueWithIdentifier:kExitPhotoSegueIdentifier sender:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.photoCaptureManager = [self.captureManager photoManager];
    [self.photoCaptureManager setPreview:self.viewFaceCapture];
    
    if(self.indicatorViewController) {
        self.indicatorViewController.frameCaptureManager = self.photoCaptureManager;
        self.indicatorViewController.viewMaskContainer = self.viewMaskContainer;
    }
    
    __weak typeof(self) weakself = self;
    [self.photoCaptureManager setLoadImageBlock:^(CIImage *ciImage, NSError *error) {
        if (error) {
            [weakself showError:error];
        } else {
            UIImage *uiImage = [weakself imageCI2UI:ciImage];
            NSData  *data    = UIImageJPEGRepresentation(uiImage, 0.9);
            
#ifdef DEBUG
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *jpgPath =  [[paths objectAtIndex:0] stringByAppendingPathComponent:@"face.jpg"];
            [data writeToFile:jpgPath atomically:YES];
#endif
            
            [weakself startActivityAnimating];
            [weakself.indicatorViewController stopObserving];
            [weakself.service addFaceSample:data
                                  forPerson:weakself.userID
                        withCompletionBlock:^(NSDictionary *responceObject, NSError *error) {
                            [weakself showError:error];
            }];
        }
    }];
    
    [self.photoCaptureManager startRunning];
    [self updateOrientation];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [self.photoCaptureManager stopRunning];
    self.photoCaptureManager = nil;
    
    if(self.indicatorViewController) {
        self.indicatorViewController.viewMaskContainer = nil;
    }

    [self stopActivityAnimating];
}

-(void)updateOrientation{
    [super updateOrientation];
    
    [self.photoCaptureManager setInterfaceOrientation:self.currentOrientation];
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
        
        __weak typeof(self) weakself = self;
        self.indicatorViewController.readyBlock = ^(BOOL isReady) {
            if (isReady) {
                weakself.isStable = YES;
                if (!weakself.isTimering) {
                    weakself.isTimering = YES;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if (weakself.isStable) {
                            if (weakself.photoCaptureManager.isRunning) {
                                [weakself startActivityAnimating];
                                [weakself.photoCaptureManager stopRunning];
                                [weakself.photoCaptureManager takePicture];
                            }
                        }
                        weakself.isTimering = NO;
                    });
                }
            } else {
                if(weakself.isTimering) {
                    weakself.isStable = NO;
                }
            }
        };
    }
}

- (IBAction)unwindTryAgain:(UIStoryboardSegue *)unwindSegue{
}

@end

@implementation OPUIEnrollFaceCaptureViewController(PrivateMethods)

-(void)showError:(NSError *)error{
    if([error.domain isEqualToString:NSURLErrorDomain]) {
        [self performSegueOnMainThreadWithIdentifier:kExitPhotoSegueIdentifier];
    } else {
        if(error) {
            [self showError:error withTitle:@"Give it another shot"];
        } else {
            [self performSegueOnMainThreadWithIdentifier:kPhotoSuccessSegueIdentifier];
        }
    }
}

-(UIImage *)imageCI2UI:(CIImage *)ciImage{
    CIContext *ciContext = [CIContext contextWithOptions:nil];
    CGImageRef cgImageRef = [ciContext createCGImage:ciImage fromRect:ciImage.extent];
    
    UIImage *nsImage = [UIImage imageWithCGImage:cgImageRef];
    
    CGImageRelease(cgImageRef);
    return nsImage;

}
@end

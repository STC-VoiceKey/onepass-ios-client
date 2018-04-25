//
//  OPUIVerifyByFaceViewController.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 15.11.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import "OPUIVerifyFaceViewController.h"

#import <OnePassCore/OnePassCore.h>
#import <OnePassCapture/OnePassCapture.h>

#import "OPUIVerifyFacePresenter.h"

#import "OPCRPreviewView.h"

#import "OPUIVerifyIndicatorViewController.h"
#import "OPUIIndicatorImageView.h"
#import "OPUIWarningView.h"

@interface OPUIVerifyFaceViewController ()

#pragma mark - Outlets
@property (nonatomic, weak) IBOutlet OPCRPreviewView *viewVideoCapture;
@property (nonatomic, weak) IBOutlet UIView          *viewMaskContainer;

@property (nonatomic, weak) IBOutlet OPUIIndicatorImageView   *imageSingleFace;
@property (nonatomic, weak) IBOutlet OPUIIndicatorImageView   *imageFaceFound;
@property (nonatomic, weak) IBOutlet OPUIIndicatorImageView   *imageEyesFound;
@property (nonatomic, weak) IBOutlet OPUIIndicatorImageView   *imageBrightness;
@property (nonatomic, weak) IBOutlet OPUIIndicatorImageView   *imageTremor;

@property (nonatomic) id<OPUIVerifyFacePresenterProtocol> presenter;

@property (nonatomic) OPUIWarningView *maskView;

@property (nonatomic) UIInterfaceOrientation interfaceOrientation;

@end

@interface OPUIVerifyFaceViewController (MaskControl)

-(void)showMask;
-(void)hideMask;
-(void)removeMask;

@end

@implementation OPUIVerifyFaceViewController

#pragma mark - Lifecircle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.presenter = [[OPUIVerifyFacePresenter alloc] init];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self attachView];
    [self updateOrientation];
}

-(void)attachView {
    [self.presenter attachView:self];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.presenter deattachView];
}

- (void)exit {
    dispatch_async( dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)highlightEyesClosedIndicator {
    self.imageEyesFound.active = YES;
}

- (void)highlightFaceOffCenterIndicator {
    self.imageFaceFound.active = YES;
}

- (void)highlightManyFacesIndicator {
    self.imageSingleFace.active = YES;
}

- (void)highlightPureLightIndicator {
    self.imageBrightness.active = YES;
}

- (void)highlightShackingIndicator {
    self.imageTremor.active = YES;
}

- (void)offEyesClosedIndicator {
    self.imageEyesFound.active = NO;
}

- (void)offFaceOffCenterIndicator {
    self.imageFaceFound.active = NO;
}

- (void)offManyFacesIndicator {
    self.imageSingleFace.active = NO;
}

- (void)offPureLightIndicator {
    self.imageBrightness.active = NO;
}

- (void)offShackingIndicator {
    self.imageTremor.active = NO;
}

- (id<IOPCCapturePhotoManagerProtocol,
         IOPCPortraitFeaturesProtocol,
              IOPCEnvironmentProtocol,
     IOPCInterfaceOrientationProtocol>)photoCaptureManager {
   return self.captureManager.photoManager;
}

- (id<IOPCPreviewView>)previewView {
    return self.viewVideoCapture;
}

- (void)showActivity {
    [self startActivityAnimating];
}

- (void)hideActivity {
    [self stopActivityAnimating];
}

- (void)showFacePositionHelper {
    [self showMask];
}

- (void)hideFacePositionHelper {
    [self hideMask];
}

-(void)showError:(NSError *)error {
    [self showErrorOnMainThread:error];
}

-(void)routeToPageWithError:(NSError *)error {
    [self showError:error
          withTitle:@"Give it another shot"];
}

-(NSString *)user{
    return self.userID;
}

@end

@implementation OPUIVerifyFaceViewController (MaskControl)

-(BOOL)isMaskShown{
    if ( (self.maskView!=nil) && (self.maskView.alpha!=0) ) {
        return YES;
    }
    return NO;
}

-(void)showMask {
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
    
//    [NSNotificationCenter.defaultCenter addObserver:self
//                                           selector:@selector(updateOrientation)
//                                               name:UIDeviceOrientationDidChangeNotification
//                                             object:nil];
}

-(void)hideMask{
    if(!self.isMaskShown) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.maskView.alpha = 0.0f;
    });
    
//    [NSNotificationCenter.defaultCenter removeObserver:self
//                                                  name:UIDeviceOrientationDidChangeNotification
//                                                object:nil];
}

-(void)addMask {
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
    }
    [self.presenter didOrientationChanged:self.currentOrientation];
}

@end

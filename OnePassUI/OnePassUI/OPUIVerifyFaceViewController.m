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

-(void)viewDidLoad{
    self.presenter = [[OPUIVerifyFacePresenter alloc] init];
    [super viewDidLoad];
}

-(void)dealloc{
    self.presenter = nil;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.presenter attachView:self];
    
    [self.presenter didOrientationChanged:self.currentOrientation];
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
    
}

-(void)hideMask{
    if(!self.isMaskShown) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.maskView.alpha = 0.0f;
    });
    
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
    
    [super updateOrientation];
}

@end


//
//  STCEnrollFaceCaptureViewController.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 14.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPUIEnrollFaceCaptureViewController.h"

#import <OnePassCore/OnePassCore.h>
#import <OnePassUICommon/OnePassUICommon.h>


static NSString *observeReady4Capture         = @"self.photoCaptureManager.isReady";
static NSString *kPhotoFailSegueIdentifier    = @"kPhotoFailSegueIdentifier";
static NSString *kPhotoSuccessSegueIdentifier = @"kPhotoSuccessSegueIdentifier";
static NSString *kExitPhotoSegueIdentifier    = @"kExitPhotoSegueIdentifier";


@interface OPUIEnrollFaceCaptureViewController ()

@property (nonatomic) id<IOPCRCapturePhotoManager,
                         IOPCREnvironment,
                         IOPCRPortraitFeatures> photoCaptureManager;

@property (nonatomic,weak) IBOutlet OPCRPreviewView   *viewFaceCapture;
@property (nonatomic,weak) IBOutlet UIButton          *captureButton;

@property (nonatomic) BOOL isObserving;

@end

@interface OPUIEnrollFaceCaptureViewController(PrivateMethods)

-(void)showError:(NSError *)error;

@end

@implementation OPUIEnrollFaceCaptureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isObserving = NO;
}

-(void)applicationDidEnterBackground{
    [self performSegueWithIdentifier:kExitPhotoSegueIdentifier sender:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self addObserver:self
           forKeyPath:observeReady4Capture
              options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
              context:nil];
    
    self.isObserving = YES;
    
    self.photoCaptureManager = [self.captureManager photoManager];
    [self.photoCaptureManager setPreview:self.viewFaceCapture];
    [self.photoCaptureManager startRunning];
    
    __weak typeof(self) weakself = self;
    [self.photoCaptureManager setLoadDataBlock:^(NSData *data, NSError *error)
    {
        if (error)  [weakself showError:error];
        else
        {
#ifdef DEBUG
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *filePath =  [[paths objectAtIndex:0] stringByAppendingPathComponent:@"enroll.jpeg"];
            [data writeToFile:filePath atomically:YES];
            NSLog(@"%lu",(unsigned long)data.length);
#endif
            [weakself.service addFaceSample:data
                              forPerson:weakself.userID
                    withCompletionBlock:^(NSDictionary *responceObject, NSError *error)
             {
                 [weakself stopActivityAnimating];
                 [weakself showError:error];
             }];
        }
    }];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.photoCaptureManager stopRunning];
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if(self.isObserving){
        [self removeObserver:self forKeyPath:observeReady4Capture];
        self.isObserving = NO;
    }
    self.photoCaptureManager = nil;

}

-(void)dealloc{
    if(self.isObserving){
        [self removeObserver:self forKeyPath:observeReady4Capture];
        self.isObserving = NO;
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{

    if([keyPath  isEqualToString:observeReady4Capture])
    {
        self.captureButton.enabled = [self.photoCaptureManager readyForCapture];
    }
}


-(IBAction)onCapture:(id)sender
{
    [self startActivityAnimating];
    
    [self.photoCaptureManager takePicture];
 
}

#pragma mark - Navigation

- (IBAction)unwindTryAgain:(UIStoryboardSegue *)unwindSegue
{
}

@end

@implementation OPUIEnrollFaceCaptureViewController(PrivateMethods)

-(void)showError:(NSError *)error{
    if([error.domain isEqualToString:NSURLErrorDomain])
    {
        [self showErrorOnMainThread:error];
    }
    else [self performSegueOnMainThreadWithIdentifier:(error ? kPhotoFailSegueIdentifier : kPhotoSuccessSegueIdentifier)];
}

@end



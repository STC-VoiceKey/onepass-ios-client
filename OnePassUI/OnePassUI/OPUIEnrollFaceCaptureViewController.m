//
//  STCEnrollFaceCaptureViewController.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 14.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPUIEnrollFaceCaptureViewController.h"
#import "OPUIAlertViewController.h"
#import "UIButton+Disable.h"

#import <OnePassCaptureResources/OnePassCaptureResources.h>
#import <OnePassCore/OnePassCore.h>


static NSString *observeReady4Capture = @"self.photoCaptureManager.isReady";
static NSString *kPhotoFailSegueIdentifier   = @"kPhotoFailSegueIdentifier";
static NSString *kPhotoSuccessSegueIdentifier = @"kPhotoSuccessSegueIdentifier";
static NSString *kExitPhotoSegueIdentifier    = @"kExitPhotoSegueIdentifier";


@interface OPUIEnrollFaceCaptureViewController ()

@property (nonatomic) OPCRCapturePhotoManager *photoCaptureManager;

@property (nonatomic,weak) IBOutlet OPCRPreviewView         *viewFaceCapture;
@property (nonatomic,weak) IBOutlet UIButton                *captureButton;

@property (nonatomic) BOOL isObserving;

@end

@implementation OPUIEnrollFaceCaptureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.photoCaptureManager = [[OPCRCapturePhotoManager alloc] initWithView:self.viewFaceCapture];
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
    [self.photoCaptureManager startRunning];
    
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
        self.captureButton.enabled = self.photoCaptureManager.readyForCapture;
    }
}


-(IBAction)onCapture:(id)sender
{
    
    if (self.photoCaptureManager.image)
    {
        [self startActivityAnimating];
        
        __weak OPUIEnrollFaceCaptureViewController *weakself = self;
        
#ifdef DEBUG
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *filePath =  [[paths objectAtIndex:0] stringByAppendingPathComponent:@"enroll.jpeg"];
        [self.photoCaptureManager.jpeg writeToFile:filePath atomically:YES];
        NSLog(@"%lu",(unsigned long)self.photoCaptureManager.jpeg.length);
#endif
        [self.service addFaceSample:self.photoCaptureManager.jpeg
                          forPerson:self.userID
                withCompletionBlock:^(NSDictionary *responceObject, NSError *error)
        {
            [weakself stopActivityAnimating];

             if([error.domain isEqualToString:NSURLErrorDomain])
             {
                 [weakself showErrorOnMainThread:error];
             }
             else [weakself performSegueOnMainThreadWithIdentifier:(error ? kPhotoFailSegueIdentifier : kPhotoSuccessSegueIdentifier)];
        }];

    }
}

#pragma mark - Navigation

- (IBAction)unwindTryAgain:(UIStoryboardSegue *)unwindSegue
{
}

@end



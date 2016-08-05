                                                                               //
//  OPUIVerifyVideoCaptureViewController.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 24.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPUIVerifyVideoCaptureViewController.h"

#import "OPUIAlertViewController.h"
#import "OPUIBlockSecondTimer.h"

@import Photos;

#import <OnePassCaptureResources/OnePassCaptureResources.h>
#import <OnePassCore/OnePassCore.h>

#import <AssetsLibrary/AssetsLibrary.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

static NSString *kVideoCaptureTimeoutName  = @"VideoCaptureTimeout";
static NSString *kVideoFailSegueIdentifier = @"kVideoFailSegueIdentifier";

static NSString *kVerifyFailSegueIdentifier    = @"kVerifyFailSegueIdentifier";
static NSString *kVerifySuccessSegueIdentifier = @"kVerifySuccessSegueIdentifier";


@interface OPUIVerifyVideoCaptureViewController ()

@property (nonatomic,weak) IBOutlet OPCRPreviewView         *viewVideoCapture;
@property (nonatomic,weak) IBOutlet UIProgressView          *timeProgress;
@property (nonatomic,weak) IBOutlet UILabel                 *sequenceLabel;
@property (nonatomic,weak) IBOutlet UIButton                *captureButton;

@property (nonatomic,strong) OPCRCaptureVideoManager *videoCaptureManager;

@property (nonatomic) id<IVerifySession> session;

@property (nonatomic) OPUIBlockSecondTimer *timer;
@property (nonatomic) OPUIBlockSecondTimer *closeVerificationSessionTimer;

@property (nonatomic) NSNumber *timeout;

@property (nonatomic) BOOL isObserving;

@end

@implementation OPUIVerifyVideoCaptureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.timeProgress.progress = 0 ;

    self.timeout  = [[NSBundle mainBundle] objectForInfoDictionaryKey:kVideoCaptureTimeoutName];
}

-(void)applicationDidEnterBackground{
    [self unwindVerifyCancel:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.videoCaptureManager = [[OPCRCaptureVideoManager alloc] initWithView:self.viewVideoCapture];
    
    [self.videoCaptureManager startRunning];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    __weak OPUIVerifyVideoCaptureViewController *weakself = self;

    self.timer = [[OPUIBlockSecondTimer alloc] initTimerWithProgressBlock:^(float seconds)
                  {
                      dispatch_async(dispatch_get_main_queue(), ^{
                          weakself.timeProgress.progress = seconds/[weakself.timeout floatValue];
                      });
                  }
                                                          withResultBlock:^(float seconds)
                  {
                      dispatch_async(dispatch_get_main_queue(), ^{
                          weakself.timeProgress.progress = 0 ;
                      });

                     if(weakself.videoCaptureManager.isRecording)
                     {
                        [weakself.videoCaptureManager stop];
                        [weakself.captureButton setSelected:NO];
                     }

                  }];
    
    self.closeVerificationSessionTimer = [[OPUIBlockSecondTimer alloc]
                                          initTimerWithProgressBlock:nil
                                          withResultBlock:^(float seconds)
                  {
                      if (!weakself.videoCaptureManager.isRecording) {
                          [self.service closeVerification:[self.session verificationSessionID]
                                      withCompletionBlock:nil];
                          dispatch_async( dispatch_get_main_queue(), ^{
                              [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                          });
                          
                      }
                      
                  }];
    [self.closeVerificationSessionTimer startWithTime:180];
    
    self.videoCaptureManager.resultBlock = ^(NSData *data, NSError *error)
    {
        dispatch_async( dispatch_get_main_queue(), ^{
            weakself.timeProgress.progress = 0;
        });
        
        if (error)
        {
            if([error.domain isEqualToString:NSURLErrorDomain])
            {
                [OPUIAlertViewController showError:error
                                withViewController:weakself
                                           handler:^(UIAlertAction *action) {
                                               dispatch_async( dispatch_get_main_queue(), ^{
                                                   [weakself.navigationController dismissViewControllerAnimated:YES completion:nil];
                                               });
                                           }];
            }
            else [weakself performSegueOnMainThreadWithIdentifier:kVerifyFailSegueIdentifier];
            
            [weakself stopActivityAnimating];
        }
        else
            
            if(weakself.service && weakself.session)
            {
                [weakself startActivityAnimating];
                
#ifdef DEBUG
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *verifyPath =  [[paths objectAtIndex:0] stringByAppendingPathComponent:@"verify.mov"];
                [data writeToFile:verifyPath atomically:YES];
#endif
                
                [weakself.service addVerificationVideo:data
                                            forSession:weakself.session.verificationSessionID
                                          withPasscode:[weakself.session passphrase]
                                   withCompletionBlock:^(NSDictionary *responceObject, NSError *error)
                 {
                     if (error)
                     {
                         [weakself stopActivityAnimating];
                         [weakself.service closeVerification:[weakself.session verificationSessionID]
                                         withCompletionBlock:nil];
                         if([error.domain isEqualToString:NSURLErrorDomain])
                             [weakself showErrorOnMainThread:error];
                         else [weakself performSegueOnMainThreadWithIdentifier:kVideoFailSegueIdentifier];
                     }
                     else
                     {
#ifdef DEBUG
                         [weakself.service verifyScore:[weakself.session verificationSessionID] withCompletionBlock:nil];
#endif
                         
                         [weakself.service verify:[weakself.session verificationSessionID]
                              withCompletionBlock:^(NSDictionary *responceObject, NSError *error)
                          {
                              [weakself stopActivityAnimating];
                              [weakself.service closeVerification:[weakself.session verificationSessionID]
                                              withCompletionBlock:nil];
                              if (!error)
                              {
                                  if ([responceObject[@"status"] isEqualToString:@"SUCCESS"])
                                      [weakself performSegueOnMainThreadWithIdentifier:kVerifySuccessSegueIdentifier];
                                  else
                                      [weakself performSegueOnMainThreadWithIdentifier:kVerifyFailSegueIdentifier];
                              }else
                                  [weakself performSegueOnMainThreadWithIdentifier:kVerifyFailSegueIdentifier];
                          }];
                         
                     }
                 }];
            };

    };

    
    [self.service startVerificationSession:self.userID
                       withCompletionBlock:^(id<IVerifySession> session, NSError *error){
                           [self stopActivityAnimating];
                           dispatch_async(dispatch_get_main_queue(), ^{
                               if(!error)
                               {
                                   weakself.session = session;
                                   weakself.sequenceLabel.text = [[PassphraseManager sharedInstance] passphraseDigitByLocalizedString:[weakself.session passphrase]];
                                   if (weakself.sequenceLabel.text==nil)
                                   {
                                       
                                       [OPUIAlertViewController showError:[NSError errorWithDomain:@"com.speachpro.onepass"
                                                                                              code:400
                                                                                          userInfo:@{ NSLocalizedDescriptionKey: @"Languages do not match"}]
                                                       withViewController:self
                                                                  handler:nil];
                                   }
                               }
                               else
                               {
                                   [OPUIAlertViewController showError:error
                                                   withViewController:self
                                                              handler:^(UIAlertAction *action) {
                                                                  dispatch_async( dispatch_get_main_queue(), ^{
                                                                      [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                                                                  });
                                                              }];
                               }
                           });
                           
                       }];

}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [self.videoCaptureManager stopRunning];
    if (self.closeVerificationSessionTimer)
    {
        [self.closeVerificationSessionTimer stop];
        [self.service closeVerification:[self.session verificationSessionID]
                    withCompletionBlock:nil];
    }

}

-(IBAction)onCapture:(id)sender{
    if (self.closeVerificationSessionTimer)
    {
        [self.closeVerificationSessionTimer stop];
        self.closeVerificationSessionTimer = nil;
    }

    if(self.videoCaptureManager.isRecording)
    {
        [self startActivityAnimating];
        [self.timer stop];
        [self.videoCaptureManager stop];
        [self.captureButton setSelected:NO];
    }
    else
    {
        [self.videoCaptureManager record];
        [self.timer startWithTime:[self.timeout floatValue]];
        [self.captureButton setSelected:YES];
    }
}


-(IBAction)unwindVerifyRetakeVideo:(UIStoryboardSegue *)unwindSegue{
    [self.captureButton setSelected:NO];
    
}
-(IBAction)unwindVerifyCancel:(UIStoryboardSegue *)unwindSegue{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)onCancell:(id)sender{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end

 //
//  OPUIBaseVoiceRecordViewController.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 22.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPUIEnrollVoiceRecordViewController.h"
#import "OPUILoader.h"

#import <OnePassCore/PassphraseManager.h>

#import <OnePassUICommon/OnePassUICommon.h>


static NSString *kVoiceCaptureTimeoutName = @"VoiceCaptureTimeout";

static NSString *kVoiceRecordStoryboardIdentifier  = @"kVoiceRecordStoryboardIdentifier";
static NSString *kVoiceFailSegueIdentifier         = @"kVoiceFailSegueIdentifier";

static NSString *kVoiceSussessSegueIdentifier  = @"kVoiceSussessSegueIdentifier";
static NSString *kExitVoiceSegueIdentifier     = @"kExitVoiceSegueIdentifier";


@interface OPUIEnrollVoiceRecordViewController()

@property (nonatomic,weak) IBOutlet UIButton        *startButton;
@property (nonatomic,weak) IBOutlet UILabel         *pageLabel;
@property (nonatomic,weak) IBOutlet UILabel         *sequenceLabel;
@property (nonatomic,weak) IBOutlet UIProgressView  *timeProgress;

@property (nonatomic,strong) id<IOPCRCaptureVoiceManager> voiceManager;

@property (nonatomic) NSArray<NSString *> *randomDigits;

@property (nonatomic) OPUIBlockSecondTimer *timer;
@property (nonatomic) NSNumber *timeout;

-(IBAction)onStart:(id)sender;

@end

@interface OPUIEnrollVoiceRecordViewController(PrivateMethods)

-(NSString *)digitSequence;
-(NSString *)wordsSequence;

-(void)showItself;

-(void)startRecord;
-(void)stopRecord;

@end

@implementation OPUIEnrollVoiceRecordViewController

#pragma mark - lifecyrcle
-(void)viewDidLoad{
    [super viewDidLoad];
    
    if(self.numberOfSample==0) self.numberOfSample = 1;
    
    self.sequenceLabel.text = [self digitSequence];
    self.pageLabel.text = [NSString stringWithFormat:@"%lu/3",(unsigned long)self.numberOfSample];
    
    self.timeProgress.progress = 0 ;
    self.timeout  = [[NSBundle mainBundle] objectForInfoDictionaryKey:kVoiceCaptureTimeoutName];
}

-(void)applicationDidEnterBackground{
    if([self.voiceManager isRecording])
        [self stopRecord];
    [self performSegueWithIdentifier:kExitVoiceSegueIdentifier sender:self];

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    __weak OPUIEnrollVoiceRecordViewController *weakself = self;
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
        if([weakself.voiceManager isRecording]) [weakself stopRecord];
    }];

    
    self.voiceManager =  [self.captureManager voiceManager];
    
    [self.voiceManager setPassphraseNumber:[NSNumber numberWithInteger:self.numberOfSample]];
    [self.voiceManager setLoadDataBlock:^(NSData *data, NSError *error)
    {
        if (!error && data)
        {
#ifdef DEBUG
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *verifyPath =  [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"reg%lu.wav",(unsigned long)weakself.numberOfSample]];
            [data writeToFile:verifyPath atomically:YES];
#endif
            [weakself startActivityAnimating];
            
            [weakself.service addVoiceFile:data
                            withPassphrase:[weakself wordsSequence]
                                 forPerson:weakself.userID
                       withCompletionBlock:^(NSDictionary *responceObject, NSError *error)
             {
                 [weakself stopActivityAnimating];
                 dispatch_async(dispatch_get_main_queue(), ^{
                     if(!error){
                         if (weakself.numberOfSample!=3) [weakself showItself];
                         else{
                             [[OPUILoader sharedInstance] enrollResultBlock](YES);
                             dispatch_async( dispatch_get_main_queue(), ^{
                                 [weakself.navigationController dismissViewControllerAnimated:YES completion:nil];
                             });
                             
                         }
                     }
                     else
                     {
                         if([error.domain isEqualToString:NSURLErrorDomain])
                         {
                             [weakself showErrorOnMainThread:error];
                             [weakself.startButton setSelected:NO];
                         }
                         else
                             [weakself performSegueOnMainThreadWithIdentifier:kVoiceFailSegueIdentifier];
                     }
                 });
             }];
        }
        else
            [weakself performSegueOnMainThreadWithIdentifier:kVoiceFailSegueIdentifier];
    }];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.voiceManager = nil;
}


#pragma  mark - IBActions
-(IBAction)onStart:(id)sender{
    if([self.voiceManager isRecording])    [self stopRecord];
    else                                   [self startRecord];
    
}

- (IBAction)unwindVoiceTryAgain:(UIStoryboardSegue *)unwindSegue
{
    [self.startButton setSelected:NO];
}

#pragma mark - Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    [super prepareForSegue:segue sender:sender];
    
    if([segue.identifier isEqualToString:kVoiceSussessSegueIdentifier]){
        OPUIEnrollVoiceRecordViewController *vc = (OPUIEnrollVoiceRecordViewController *)segue.destinationViewController;
        vc.numberOfSample = self.numberOfSample+1;
    }
}

@end

@implementation OPUIEnrollVoiceRecordViewController(PrivateMethods)

-(void)startRecord{
    [self.startButton setSelected:YES];
    [self.voiceManager record];
    [self.timer startWithTime:[self.timeout floatValue]];
    
}
-(void)stopRecord
{
    [self.timer stop];
    self.timeProgress.progress = 0 ;
    [self.voiceManager stop];
}

-(void)showItself
{
    OPUIEnrollVoiceRecordViewController *vc = (OPUIEnrollVoiceRecordViewController *)[[UIStoryboard storyboardWithName:@"Enroll"
                                                                                                                bundle: [NSBundle bundleForClass:[self class]]]
                                                                               instantiateViewControllerWithIdentifier:kVoiceRecordStoryboardIdentifier];
    vc.numberOfSample = self.numberOfSample + 1;
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(NSString *)digitSequence{
    
    switch (self.numberOfSample)
    {
        case 1: return [[PassphraseManager sharedInstance] passphraseDigitString];
        case 2: return [[PassphraseManager sharedInstance] passphraseReverseDigitString];
        case 3: self.randomDigits = [[PassphraseManager sharedInstance] passphraseRandomDigitArray];
            return [[PassphraseManager sharedInstance] passphraseRandomStringWithArray:self.randomDigits];
    }
    
    return nil;
}

-(NSString *)wordsSequence
{
    switch (self.numberOfSample)
    {
        case 1: return [[PassphraseManager sharedInstance] passphraseLocalizedString];
        case 2: return [[PassphraseManager sharedInstance] passphraseReverseString];
        case 3: return [[PassphraseManager sharedInstance] passphraseRandomStringWithArray:[[PassphraseManager sharedInstance] passphraseRandomArray:self.randomDigits]];
    }
    
    return nil;
}

@end
//
//  OPUIBaseVoiceRecordViewController.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 22.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPUIEnrollVoiceRecordViewController.h"
#import "OPUILoader.h"
#import "UIActivityIndicatorView+Status.h"
#import "OPUIVoiceVisualizerView.h"
#import "OPUIBlockCentisecondsTimer.h"

#import <OnePassCore/OPCPassphraseManager.h>
#import <OnePassCapture/OnePassCapture.h>

static NSString *kVoiceCaptureTimeoutName = @"VoiceCaptureTimeout";

#pragma mark - Segue Identifiers
static NSString *kVoiceRecordStoryboardIdentifier  = @"kVoiceRecordStoryboardIdentifier";
static NSString *kVoiceSussessSegueIdentifier      = @"kVoiceSussessSegueIdentifier";
static NSString *kExitVoiceSegueIdentifier         = @"kExitVoiceSegueIdentifier";

#pragma mark - Observation Fields
static NSString *observeNoiseValue   = @"self.voiceManager.isNoNoisy";

@interface OPUIEnrollVoiceRecordViewController()

#pragma mark - Outlets
@property (nonatomic, weak) IBOutlet UIButton        *startButton;
@property (nonatomic, weak) IBOutlet UILabel         *pageLabel;
@property (nonatomic, weak) IBOutlet UILabel         *sequenceLabel;
@property (nonatomic, weak) IBOutlet UIProgressView  *timeProgress;
@property (nonatomic, weak) IBOutlet UIView          *noiseIndicator;
@property (nonatomic, weak) IBOutlet OPUIVoiceVisualizerView *voiceView;

/**
 The manager of the capture voice
 */
@property (nonatomic, strong) id<IOPCCaptureVoiceManagerProtocol>  voiceManager;

/**
 The manager which provides information about the noise enviroment
 */
@property (nonatomic, strong) id<IOPCNoisyProtocol>                noiseAnalyzer;
/**
 The manager which displays voice wave
 */
@property (nonatomic, weak)   id<IOPCIsVoiceVisualizerProtocol>    voiceVisualizer;

/**
 Keeps the randomized digits sequence
 */
@property (nonatomic) NSArray<NSString *> *randomDigits;

/**
 The value of the voice duration
 */
@property (nonatomic) NSNumber    *timeout;

/**
 The timer that fires when the voice should be finished
 */
@property (nonatomic) OPUIBlockCentisecondsTimer *voiceLimitDurationTimer;

/**
 The manager for creating and controlling the passphrase
 */
@property (nonatomic) OPCPassphraseManager *passphraseManager;

/**
 Starts recording

 @param sender The sender
 */
-(IBAction)onStart:(id)sender;

@end

@interface OPUIEnrollVoiceRecordViewController(PrivateMethods)

/**
 Forms the digit sequence based on the order number of voice sample
 
 @return The word sequence
 */
-(NSString *)digitSequence;

/**
 Forms the word sequence based on the digit sequence

 @return The word sequence
 */
-(NSString *)wordsSequence;

/**
 Starts recording
 */
-(void)startRecord;

/**
 Stops recording
 */
-(void)stopRecord;

/**
 Sets sequence label parameters
 */
-(void)setupSequenceLabel;

/**
 Sets sequence time progress parameters
 */
-(void)setupTimeProgress;

/**
 Shows the activity indicators with the status marker

 @param error The error
 */
-(void)setupActivityIndicatorWithError:(NSError *)error;

/**
 Closes screen
 */
-(void)close;

@end

@implementation OPUIEnrollVoiceRecordViewController

#pragma mark - Lifecyrcle
-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.passphraseManager = OPCPassphraseManager.sharedInstance;
    
    [self setupSequenceLabel];
    [self setupTimeProgress];
}

-(void)applicationDidEnterBackground{
    [self close];
}

-(void)viewTimerDidExpared{
    if(!self.voiceManager.isRecording) {
        [self close];
    }
}

-(void)networkStateChanged:(BOOL)isHostAccessable{
    if (!isHostAccessable) {
         [self close];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.startButton setSelected:NO];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.activityIndicator resetActivityIndicatorStatus];
    
    __weak typeof(self) weakself = self;
    self.voiceLimitDurationTimer = [[OPUIBlockCentisecondsTimer alloc] initTimerWithProgressBlock:^(float seconds){
        dispatch_async(dispatch_get_main_queue(), ^{
            weakself.timeProgress.progress = seconds * 10/[weakself.timeout floatValue];
        });
    }
                                                                                  withResultBlock:^(float seconds)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakself.timeProgress.progress = 0 ;
        });
        
        if([weakself.voiceManager isRecording]) {
            [weakself startActivityAnimating];
            [weakself stopRecord];
        }
    }];

    self.voiceManager =  [self.captureManager voiceManager];
    
    if([self.voiceManager conformsToProtocol:@protocol(IOPCIsVoiceVisualizerProtocol)]) {
        self.voiceVisualizer = (id<IOPCIsVoiceVisualizerProtocol>)self.voiceManager;
        [self.voiceVisualizer setPreview:self.voiceView];
    }
    
    if([self.voiceManager conformsToProtocol:@protocol(IOPCNoisyProtocol)]) {
        [self addObserverForKeyPath:observeNoiseValue];

        self.noiseIndicator.hidden = NO;

        self.noiseAnalyzer = (id<IOPCNoisyProtocol>)self.voiceManager;
        [self.noiseAnalyzer startNoiseAnalyzer];
    }
    
    [self.voiceManager setPassphraseNumber:[NSNumber numberWithInteger:self.numberOfSample]];
    if([self.voiceManager respondsToSelector:@selector(setPassphrase:)]) {
        [self.voiceManager setPassphrase:self.wordsSequence];
    }
    
    [self.voiceManager setLoadDataBlock:^(NSData *data, NSError *error) {
        [weakself startActivityAnimating];
        [weakself.voiceLimitDurationTimer stop];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weakself.timeProgress.progress = 0 ;
        });
        
        if (!error && data) {
            
            [weakself.service addVoiceFile:data
                            withPassphrase:[weakself wordsSequence]
                                 forPerson:weakself.userID
                       withCompletionBlock:^(NSDictionary *responceObject, NSError *error) {
                 
                           [weakself setupActivityIndicatorWithError:error];
                           
                           dispatch_async(dispatch_get_main_queue(), ^{
                               if(!error) {
                                   if (weakself.numberOfSample != 3) {
                                       [weakself performSegueOnMainThreadWithIdentifier:kVoiceSussessSegueIdentifier];
                                   } else {
                                       [weakself startActivityAnimating];
                                       
                                       [OPUILoader.sharedInstance enrollResultBlock](YES,nil);
                                       dispatch_async( dispatch_get_main_queue(), ^{
                                           [weakself.navigationController dismissViewControllerAnimated:YES completion:nil];
                                       });
                                   }
                               } else {
                                   if([error.domain isEqualToString:NSURLErrorDomain]) {
                                       //[weakself showErrorOnMainThread:error];
                                       [weakself close];
                                   } else {
                                       [weakself showError:error withTitle:@"Give it another voice"];
                                   }
                               }
                               [weakself stopActivityAnimating];
                           });
                       }];
        }
        else {
            [weakself showError:error withTitle:@"Give it another voice"];
        }
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.voiceView.hidden = YES;
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    if([self.voiceManager isRecording]) {
        [self.voiceManager stop];
    } else {
        if (self.noiseAnalyzer) {
            [self removeObserver:self forKeyPath:observeNoiseValue];
            
            [self.noiseAnalyzer stopNoiseAnalyzer];
            self.noiseAnalyzer = nil;
        } 
    }
    
    self.voiceManager = nil;
}

-(void)dealloc{
    if(_noiseAnalyzer) {
        [self removeObserver:self forKeyPath:observeNoiseValue];
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                      context:(void *)context{
    
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    
    if ([keyPath isEqualToString:observeNoiseValue]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.noiseIndicator.hidden = [self.noiseAnalyzer isNoNoisy];
            self.startButton.enabled = self.noiseIndicator.hidden;
        });
    }
}

#pragma mark - IBActions
-(IBAction)onStart:(id)sender{
    
    if([self.voiceManager isRecording]) {
        self.voiceView.hidden = YES;
        [self startActivityAnimating];
        [self stopRecord];
    } else {
        self.voiceView.hidden = NO;
        [self startRecord];
    }
}

- (IBAction)unwindVoiceTryAgain:(UIStoryboardSegue *)unwindSegue{
    [self.startButton setSelected:NO];
}

#pragma mark - Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    [super prepareForSegue:segue sender:sender];
  
    if([segue.identifier isEqualToString:kVoiceSussessSegueIdentifier]) {
        OPUIEnrollVoiceRecordViewController *vc = (OPUIEnrollVoiceRecordViewController *)segue.destinationViewController;
        vc.numberOfSample = self.numberOfSample + 1;
    }
    
    if([segue.identifier isEqualToString:kExitVoiceSegueIdentifier]) {
        [self.voiceManager setLoadDataBlock:nil];
    }
}

@end

@implementation OPUIEnrollVoiceRecordViewController(PrivateMethods)

-(void)startRecord{
    if (self.noiseAnalyzer) {
        [self.noiseAnalyzer stopNoiseAnalyzer];
    }
    
    self.startButton.selected = YES;
    
    [self.voiceManager record];
    [self.voiceLimitDurationTimer startWithTime:self.timeout.floatValue];
}

-(void)stopRecord{
    [self.voiceManager stop];
}

-(NSString *)digitSequence{
    switch (self.numberOfSample) {
        case 1:
            return self.passphraseManager.passphraseSymbolString;
        case 2:
            return self.passphraseManager.passphraseReverseSymbolString;
        case 3:
            self.randomDigits = self.passphraseManager.passphraseRandomSymbolArray;
            return [self.passphraseManager  passphraseRandomStringWithArray:self.randomDigits];
    }
    return nil;
}

-(NSString *)wordsSequence{
    switch (self.numberOfSample) {
        case 1:
            return self.passphraseManager.passphraseLocalizedSymbolString;
        case 2:
            return self.passphraseManager.passphraseLocalizedReverseSymbolString;
        case 3:
            return [self.passphraseManager passphraseRandomStringWithArray:[OPCPassphraseManager.sharedInstance passphraseRandomizeArray:self.randomDigits]];
    }
    return nil;
}

-(void)setupSequenceLabel{
    
    if(self.numberOfSample == 0) {
        self.numberOfSample = 1;
    }
    
    self.sequenceLabel.text = self.digitSequence;
    self.pageLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.numberOfSample];
    [self.pageLabel sizeToFit];
}

-(void)setupTimeProgress{
    self.timeProgress.progress = 0 ;
    self.timeout = [NSBundle.mainBundle objectForInfoDictionaryKey:kVoiceCaptureTimeoutName];
    self.timeout = @(100*self.timeout.floatValue);
}

-(void)setupActivityIndicatorWithError:(NSError *)error{
    if(error) {
        [self.activityIndicator setActivityIndicatorStatus2Fail];
    } else {
        [self.activityIndicator setActivityIndicatorStatus2Success];
    }
}

-(void)close {
    if([self.voiceManager isRecording]) {
        [self.voiceManager setLoadDataBlock:nil];
        [self stopRecord];
    }
    
    [self performSegueWithIdentifier:kExitVoiceSegueIdentifier sender:self];
}

@end

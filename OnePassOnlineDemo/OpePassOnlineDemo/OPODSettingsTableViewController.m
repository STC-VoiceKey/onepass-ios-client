//
//  OPODSettingsTableViewController.m
//  OnePassOnlineDemo
//
//  Created by Soloshcheva Aleksandra on 17.10.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//
#import <OnePassUI/OnePassUI.h>

#import "OPODSettingsTableViewController.h"
#import "IOPODSettingProtocol.h"
#import "OPODConfigurationPresenter.h"

static NSString *kConfigureURLSegueIdentifier = @"kConfigureURLSegueIdentifier";

static NSString *kConfigureSessionUsernameSegueIdentifier = @"kConfigureSessionUsernameSegueIdentifier";
static NSString *kConfigureSessionPasswordSegueIdentifier = @"kConfigureSessionPasswordSegueIdentifier";
static NSString *kConfigureSessionDomainSegueIdentifier   = @"kConfigureSessionDomainSegueIdentifier";

static NSString *kUnwindSettingsSegueIdentifier = @"kUnwindSettingsSegueIdentifier";

@interface OPODSettingsTableViewController ()<IOPODSettingsViewProtocol>

@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@property (weak, nonatomic) IBOutlet UILabel *urlLabel;

@property (weak, nonatomic) IBOutlet UILabel *userLabel;

@property (weak, nonatomic) IBOutlet UISwitch *faceSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *voiceSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *staticVoiceSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *livenessSwitch;

@property (weak, nonatomic) IBOutlet UISegmentedControl *resolutionControl;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;

@property (nonatomic) id<IOPODSettingsPresenterProtocol> presenter;

@end

@interface OPODSettingsTableViewController (Private)

-(void)highlightLabel:(UILabel *)label;
-(void)resetHighlightLabel:(UILabel *)label;

-(void)showModalitiesWarning;
-(void)showVoiceModalitiesWarning;

@end

@implementation OPODSettingsTableViewController

#pragma mark - Lifecircle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.presenter = [[OPODConfigurationPresenter alloc] init];
}

-(void)viewWillAppear:(BOOL)animated {
    [self.presenter attachView:self];
}

-(void)viewDidDisappear:(BOOL)animated {
    [self.presenter deattachView];
}

#pragma mark - IOPODConfigurationViewProtocol
-(void)showVersion:(NSString *)version {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.versionLabel.text = version;
    });
}

- (void)showURL:(NSString *)url {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.urlLabel.text = url;
    });
}

- (void)showUser:(NSString *)user {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.userLabel.text = user;
    });
}

- (void)hideActivityView {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.activityView stopAnimating];
    });
}

- (void)showActivityView {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.activityView startAnimating];
    });
}

-(void)showModalities:(NSDictionary *)modalities {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.faceSwitch.on     = [modalities[@"face"] boolValue];
        self.voiceSwitch.on    = [modalities[@"voice"] boolValue];
        self.livenessSwitch.on = [modalities[@"liveness"] boolValue];
    });
}

-(void)showFaceModality:(BOOL)isFace {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.faceSwitch.on = isFace;
    });
}

-(void)showVoiceModality:(BOOL)isVoice {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.voiceSwitch.on = isVoice;
    });
}

-(void)showStaticVoiceModality:(BOOL)isStaticVoice {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.staticVoiceSwitch.on = isStaticVoice;
    });
}

-(void)showLivenessModality:(BOOL)isLiveness{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.livenessSwitch.on = isLiveness;
    });
}

-(void)enabledFaceModality {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.faceSwitch.enabled = YES;
    });
}

-(void)enabledVoiceModality {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.voiceSwitch.enabled = YES;
    });
}

-(void)enabledStaticVoiceModality {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.staticVoiceSwitch.enabled = YES;
    });
}

-(void)enabledLivenessModality {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.livenessSwitch.enabled = YES;
    });
}

-(void)disableFaceModality {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.faceSwitch.enabled = NO;
    });
}

-(void)disableVoiceModality {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.voiceSwitch.enabled = NO;
    });
}

-(void)disableStaticVoiceModality {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.staticVoiceSwitch.enabled = NO;
    });
}

-(void)disableLivenessModality {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.livenessSwitch.enabled = NO;
    });
}

-(void)highlightURL {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self highlightLabel:self.urlLabel];
    });
}

-(void)resetHighlightURL {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self resetHighlightLabel:self.urlLabel];
    });
}

-(void)showError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        [OPUIAlertViewController showError:error
                        withViewController:self
                                   handler:nil];
    });
}

-(void)showDeleteUserWarningWithHandler:(void (^)(UIAlertAction *action))handler{
    NSString *warning = [NSString stringWithFormat:NSLocalizedString(@"Are you sure you want to remove user %@?",
                                                                     @"Are you sure you want to remove user {person}"), self.userLabel.text];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [OPUIAlertViewController showWarning:warning
                                  withHeader:NSLocalizedString(@"Delete User",nil)
                          withViewController:self
                               cancelHandler:nil
                               deleteHandler:handler];
    });
}

-(void)showDeleteUserResultWarningWithHandler:(void (^)(UIAlertAction *action))handler{
    dispatch_async(dispatch_get_main_queue(), ^{
        [OPUIAlertViewController showWarning:NSLocalizedString(@"The user has been successfully removed", nil)
                          withViewController:self
                                     handler:handler];
    });
}

- (void)setLargeResolution {
     dispatch_async(dispatch_get_main_queue(), ^{
         [self.resolutionControl setSelectedSegmentIndex:1];
     });
}


- (void)setSmallResolution {
     dispatch_async(dispatch_get_main_queue(), ^{
         [self.resolutionControl setSelectedSegmentIndex:0];
    });
}

- (void)showModalityWarning {
    
}



-(void)exit{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.textColor = [UIColor colorWithRed:255.0/255.0
                                                 green:219.0/255.0
                                                  blue:072.0/255.0
                                                 alpha:1.0];
}

#pragma mark - IBActions
-(IBAction)onExit:(id)sender {
    if (![self.presenter isModalitiesValid]) {
        if (![self.presenter isVoiceModalitiesValid]) {
            [self showVoiceModalitiesWarning];
        } else {
            [self showModalitiesWarning];
        }
        return ;
    }
    [self.presenter saveModalities];
    [self exit];
}

-(IBAction)onDelete:(id)sender {
    [self.presenter deleteUser:self.userLabel.text];
}

-(IBAction)onFaceSwitched:(id)sender {
    [self.presenter changeFaceModality:self.faceSwitch.isOn];
}

-(IBAction)onVoiceSwitched:(id)sender {
    [self.presenter changeVoiceModality:self.voiceSwitch.isOn];
}

-(IBAction)onStaticVoiceSwitched:(id)sender {
    [self.presenter changeStaticVoiceModality:self.staticVoiceSwitch.isOn];
}

-(IBAction)onLivenessSwitched:(id)sender {
    [self.presenter changeLivenessModality:self.livenessSwitch.isOn];
}

-(IBAction)onResolutionChanged:(id)sender {
    BOOL isSmallResolution = ( self.resolutionControl.selectedSegmentIndex == 0 );
    [self.presenter changeResolution:isSmallResolution];
}

#pragma mark - Navigation

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:kUnwindSettingsSegueIdentifier]) {
        if (![self.presenter isModalitiesValid]) {
            if (![self.presenter isVoiceModalitiesValid]) {
                [self showVoiceModalitiesWarning];
            } else {
                [self showModalitiesWarning];
            }
            return NO;
        }
        [self.presenter saveModalities];
    }
    return YES;
}

@end

@implementation OPODSettingsTableViewController (Private)

-(void)highlightLabel:(UILabel *)label {
    label.shadowColor = UIColor.redColor;
    label.textColor   = UIColor.redColor;
    label.alpha       = 0.5;
}

-(void)resetHighlightLabel:(UILabel *)label {
    label.shadowColor = UIColor.clearColor;
    label.textColor   = UIColor.whiteColor;
    label.alpha       = 1;
}

-(void)showModalitiesWarning{
    dispatch_async(dispatch_get_main_queue(), ^{
        [OPUIAlertViewController showWarning:NSLocalizedString(@"You can not disable all modalities. At least one modality must be enabled.", nil)
                          withViewController:self
                                     handler:nil];
    });
}

-(void)showVoiceModalitiesWarning{
    dispatch_async(dispatch_get_main_queue(), ^{
        [OPUIAlertViewController showWarning:NSLocalizedString(@"Choose one voice modatity.", nil)
                          withViewController:self
                                     handler:nil];
    });
}

@end

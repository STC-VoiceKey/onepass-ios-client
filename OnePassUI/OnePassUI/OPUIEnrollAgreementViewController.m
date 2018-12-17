//
//  OPUIAgreementViewController.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 30.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPUIEnrollAgreementViewController.h"
#import "OPUICorporateColorUtils.h"
#import "OPUIEnrollAgreementPresenterProtocol.h"
#import "OPUIEnrollAgreementPresenter.h"
#import <OnePassCapture/OnePassCapture.h>

static NSString *kFaceCaptureSegueIdentifier  = @"kFaceCaptureSegueIdentifier";
static NSString *kVoiceCaptureSegueIdentifier = @"kVoiceCaptureSegueIdentifier";
static NSString *kStaticVoiceSegueIdentifier  = @"kStaticVoiceSegueIdentifier";

static NSString *kCauseListTableCellIdentifier = @"causeListTableCellIdentifier";

@interface OPUIEnrollAgreementViewController ()

/**
 The table view of requirements
 */
@property (nonatomic,weak) IBOutlet UITableView *tableView;

/**
 The data source of table view of requirements
 */
@property (nonatomic,strong) NSArray *dataSource;

@property (nonatomic) id<OPUIEnrollAgreementPresenterProtocol> presenter;

@end

@interface OPUIEnrollAgreementViewController (Private)

-(void)configureTextLabelCell:(UILabel *)label;
-(void)configureImageCell:(UIImageView *)imageView;

-(NSString *)causeFromRow:(NSDictionary *)row;
-(UIImage *)imageFromRow:(NSDictionary *)row;

@end

@implementation OPUIEnrollAgreementViewController

#pragma mark - Navigation
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.presenter = [[OPUIEnrollAgreementPresenter alloc] init];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView  = [[UIView alloc] init];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.presenter attachView:self];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.presenter deattachView];
}

-(void)applicationDidEnterBackground{
    [self  exit];
}

#pragma mark - Navigation
-(IBAction)onCancel:(id)sender{
    [self.presenter onCancel];
}

-(IBAction)unwindCancel:(UIStoryboardSegue *)unwindSegue{
    [self exit];
}

- (IBAction)onContinue:(id)sender {
    [self.presenter onContinue];
}

-(void)exit {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:kCauseListTableCellIdentifier];
    if (cell) {
        cell.backgroundColor = [UIColor clearColor];

        NSDictionary *row = [_dataSource objectAtIndex:indexPath.row];

        [self configureTextLabelCell:cell.textLabel];
        cell.textLabel.text = [self causeFromRow:row];

        [self configureImageCell:cell.imageView];
        cell.imageView.image = [self imageFromRow:row];
        
    } else {
        cell = [[UITableViewCell alloc] init];
    }
    
    return cell;
}

#pragma mark - OPUIEnrollAgreementViewProtocol

- (void)routeToFacePage {
    [self performSegueOnMainThreadWithIdentifier:kFaceCaptureSegueIdentifier];
}

- (void)routeToVoicePage {
    [self performSegueOnMainThreadWithIdentifier:kVoiceCaptureSegueIdentifier];
}

- (void)routeToStaticVoicePage {
    [self performSegueOnMainThreadWithIdentifier:kStaticVoiceSegueIdentifier];
}


- (void)showWarnings:(NSArray<NSString *> *)source {
    self.dataSource = source;
    [self.tableView reloadData];
}

@end

@implementation OPUIEnrollAgreementViewController (Private)

-(void)configureTextLabelCell:(UILabel *)label {
    label.textColor = OPUIWhiteWithAlpha(1);
    label.font = OPUIFontSFRegularWithSize(17);
    label.numberOfLines = 3;
}

-(void)configureImageCell:(UIImageView *)imageView {
    imageView.alpha = 0.35;
    imageView.image = [imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    imageView.tintColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1];
}

-(NSString *)causeFromRow:(NSDictionary *)row {
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    return NSLocalizedStringFromTableInBundle(row[@"cause"], @"OnePassUILocalizable", bundle, nil);
}

-(UIImage *)imageFromRow:(NSDictionary *)row {
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    return  [UIImage imageNamed:row[@"image"]
                       inBundle:bundle
  compatibleWithTraitCollection:nil];
}

@end


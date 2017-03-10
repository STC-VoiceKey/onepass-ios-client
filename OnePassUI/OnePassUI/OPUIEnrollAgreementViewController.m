//
//  OPUIAgreementViewController.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 30.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPUIEnrollAgreementViewController.h"
#import "OPUICorporateColorUtils.h"
#import <OnePassCapture/OnePassCapture.h>

static NSString *kCauseListTableCellIdentifier = @"causeListTableCellIdentifier";

static NSString *kCauseField = @"cause";
static NSString *kImageField = @"image";

@interface OPUIEnrollAgreementViewController ()

/**
 The table view of requirements
 */
@property (nonatomic,weak) IBOutlet UITableView *tableView;

/**
 The data source of table view of requirements
 */
@property (nonatomic,strong) NSArray *dataSource;

@end

@implementation OPUIEnrollAgreementViewController

#pragma mark - Navigation
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView  = [[UIView alloc] init];
    
    self.dataSource = @[@{ kImageField:@"light",        kCauseField:@"Find a well lit place"},
                        @{ kImageField:@"silence",      kCauseField:@"Make sure it's quiet"},
                        @{ kImageField:@"eyesnotfound", kCauseField:@"Take off sunglasses"},
                        @{ kImageField:@"otherface",    kCauseField:@"Make your ordinary face"}];
}

-(void)applicationDidEnterBackground{
    [self  unwindCancel:nil];
}

#pragma mark - Navigation
-(IBAction)onCancel:(id)sender{
    [self  unwindCancel:nil];
}

-(IBAction)unwindCancel:(UIStoryboardSegue *)unwindSegue{
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
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        cell.textLabel.text = NSLocalizedStringFromTableInBundle(row[kCauseField], @"OnePassUILocalizable", bundle, nil);
        cell.textLabel.textColor = OPUIWhiteWithAlpha(1);
        cell.textLabel.font = OPUIFontSFRegularWithSize(17);
        cell.textLabel.numberOfLines = 3;

        cell.imageView.image = [UIImage imageNamed:row[kImageField]
                                          inBundle:bundle
                     compatibleWithTraitCollection:nil];
        cell.imageView.alpha = 0.35;
        cell.imageView.image = [cell.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        cell.imageView.tintColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1];
        
    } else {
        cell = [[UITableViewCell alloc] init];
    }
    
    return cell;
}

@end


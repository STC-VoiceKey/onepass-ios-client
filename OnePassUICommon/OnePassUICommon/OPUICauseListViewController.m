//
//  OPUICauseListViewController.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 19.07.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPUICauseListViewController.h"
#import "OPUICorporateColorUtils.h"

static NSString *kCauseListTableCellIdentifier = @"causeListTableCellIdentifier";

@implementation OPUICauseListViewController

-(void)viewDidLoad{
    [super viewDidLoad];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:kCauseListTableCellIdentifier];
    if (cell) {
        cell.backgroundColor = OPUICorporateColdWhite;
        cell.textLabel.textColor = OPUICorporateDarkBlue;
        
        NSDictionary *row = [_dataSource objectAtIndex:indexPath.row];
        
        NSString *localizedString =  NSLocalizedStringFromTableInBundle(row[@"cause"], @"OnePassUILocalizable",[NSBundle bundleForClass:[self class]], nil);
        
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.numberOfLines = 3;
        cell.textLabel.text = NSLocalizedString( localizedString, nil);
        
        cell.imageView.image = [UIImage imageNamed:row[@"image"]
                                          inBundle:[NSBundle bundleForClass:[self class]]
                     compatibleWithTraitCollection:nil];
    }else cell = [[UITableViewCell alloc] init];
    
    return cell;
}
@end

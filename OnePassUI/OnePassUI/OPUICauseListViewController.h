//
//  OPUICauseListViewController.h
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 19.07.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPUIBaseViewController.h"

@interface OPUICauseListViewController : OPUIBaseViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray *dataSource;

@end
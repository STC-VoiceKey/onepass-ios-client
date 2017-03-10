//
//  OPUIErrorViewController.h
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 10.11.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OPUIBaseViewController.h"

/**
 The view controller shows the error
 */
@interface OPUIErrorViewController : OPUIBaseViewController

/**
 The title of the form
 */
@property (nonatomic) NSString *titleWarning;

/**
 The shown error
 */
@property (nonatomic) NSError  *error;

@end

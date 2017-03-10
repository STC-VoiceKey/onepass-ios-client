//
//  OPUIErrorViewController.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 10.11.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPUIErrorViewController.h"

@interface OPUIErrorViewController ()

@property (nonatomic, weak) IBOutlet UILabel    *titleLabel;
@property (nonatomic, weak) IBOutlet UITextView *errorLabel;

@end

@implementation OPUIErrorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = self.titleWarning;
    self.errorLabel.text = self.error.localizedDescription;
}

-(IBAction)onTryAgain:(id)sender{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end

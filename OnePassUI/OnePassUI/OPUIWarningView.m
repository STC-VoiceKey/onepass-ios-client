//
//  OPUIWarningView.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 12.12.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPUIWarningView.h"

@interface OPUIWarningView()

@property (nonatomic,weak) IBOutlet UILabel *warningLabel;

@end

@implementation OPUIWarningView

-(void)setWarning:(NSString *)warning{
    _warning = warning;
    self.warningLabel.text = _warning;
}

@end

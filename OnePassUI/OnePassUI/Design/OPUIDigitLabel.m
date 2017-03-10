//
//  OPUIDigitLabel.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 07.11.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPUIDigitLabel.h"
#import "OPUICorporateColorUtils.h"
#import <OnePassCapture/OnePassCapture.h>

@implementation OPUIDigitLabel

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
}

-(void)setText:(NSString *)text{
    
    self.numberOfLines = 2;
    
    [super setText:text];
    
    NSArray *lineArray = [text componentsSeparatedByString:@"\n"];
    
    NSMutableAttributedString *label = [[NSMutableAttributedString alloc] initWithString:lineArray.firstObject
                                        attributes:@{NSForegroundColorAttributeName : self.firstLabelColor,
                                                                NSFontAttributeName : OPUIFontSFRegularWithSize(17)}];
    [label appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
    NSMutableAttributedString *digit = [[NSMutableAttributedString alloc] initWithString:lineArray.lastObject
                                        attributes:@{NSForegroundColorAttributeName : self.secondLabelColor,
                                                                NSFontAttributeName : OPUIFontSFBoldWithSize(36),
                                                                NSKernAttributeName : @(7)}];
    
    [label appendAttributedString:digit];
    
    self.attributedText = label;
}

@end

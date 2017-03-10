//
//  OPUIBackgroundView.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 20.10.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPUIBackgroundView.h"
#import <OnePassCapture/OnePassCapture.h>
#import "UIImage+Blur.h"

@implementation OPUIBackgroundView

- (void)drawRect:(CGRect)rect {
    UIView *glassView = [[UIView alloc] initWithFrame:self.bounds];
    glassView.backgroundColor = [UIColor colorWithRed:45.0/255.0 green:164.0/255.0 blue:183.0/255.0 alpha:0.9];
    [self addSubview:glassView];
    [self sendSubviewToBack:glassView];
    
    NSString *resourcePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"backgroundPattern" ofType:@"png"];
    UIImageView *back = [[UIImageView alloc] initWithFrame:self.bounds];
    back.image = [[UIImage imageWithContentsOfFile:resourcePath] blurWithInputRadius:10];
    [self addSubview:back];
    [self sendSubviewToBack:back];
    
    self.glassView = glassView;
    self.backView  = back;
}

@end

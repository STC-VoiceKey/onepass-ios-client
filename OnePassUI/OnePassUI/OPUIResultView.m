//
//  OPUIResultView.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 08.11.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPUIResultView.h"
#import "OPUIDivergentCirclesView.h"

@interface OPUIResultView()

@property (nonatomic,weak) IBOutlet UIButton *button;

@end

@implementation OPUIResultView

- (void)drawRect:(CGRect)rect{
    OPUIDivergentCirclesView *view = [[OPUIDivergentCirclesView alloc] initWithFrame:self.bounds];
    view.failStatus = self.fail;
    view.backgroundColor = UIColor.clearColor;
    view.tintColor = self.tintColor;
    view.radius = self.radius;
    [view setNeedsDisplay];
    
    [self addSubview:view];
    [self bringSubviewToFront:view];
    [self bringSubviewToFront:self.button];
}

@end

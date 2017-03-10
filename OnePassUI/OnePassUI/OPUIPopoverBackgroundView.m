//
//  OPUIPopoverBackgroundView.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 26.10.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPUIPopoverBackgroundView.h"

#define CONTENT_INSET 10.0
#define CAP_INSET     25.0
#define ARROW_BASE    25.0
#define ARROW_HEIGHT  25.0

@implementation OPUIPopoverBackgroundView
{
    CGFloat _arrowOffset;
    UIPopoverArrowDirection _arrowDirection;
}

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.alpha = 0.0;
    }
    return self;
}

- (CGFloat) arrowOffset {
    return _arrowOffset;
}

- (void) setArrowOffset:(CGFloat)arrowOffset {
    _arrowOffset = arrowOffset;
}

- (UIPopoverArrowDirection)arrowDirection {
    return _arrowDirection;
}

- (void)setArrowDirection:(UIPopoverArrowDirection)arrowDirection {
    _arrowDirection = arrowDirection;
}


+(UIEdgeInsets)contentViewInsets{
    return UIEdgeInsetsMake(CONTENT_INSET, CONTENT_INSET, CONTENT_INSET, CONTENT_INSET);
}

+(CGFloat)arrowHeight{
    return ARROW_HEIGHT;
}

+(CGFloat)arrowBase{
    return ARROW_BASE;
}

-  (void)layoutSubviews {
    [super layoutSubviews];
}

@end

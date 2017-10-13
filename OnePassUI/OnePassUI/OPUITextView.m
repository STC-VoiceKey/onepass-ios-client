//
//  OPUITextView.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 04.10.17.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import "OPUITextView.h"
#import "OPUICorporateColorUtils.h"
#import "UITextView+Placeholder.h"

@interface OPUITextView()

/**
 The warning label placed under the text field
 */
@property (nonatomic) UILabel  *warningLabel;

@end

@interface OPUITextView(PrivateMethods)

/**
 Draws two lines above and below the text view
 */
-(void)drawYellowBorder;

/**
 Creates the label to display the warning
 
 @return The warning label
 */
-(UILabel *)createWarningLabel;

@end

@implementation OPUITextView

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.textContainerInset = UIEdgeInsetsMake(9, 34, 0, 0);
    self.textContainer.maximumNumberOfLines = 1;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    self.textColor = UIColor.whiteColor;
    self.tintColor = OPUIYellowWithAlpha(1);
    
    [self drawYellowBorder];
    
    if(self.placeholder) {
        NSDictionary *placeholderAttributes = @{NSForegroundColorAttributeName:OPUIWhiteWithAlpha(0.5),
                                                NSFontAttributeName:[UIFont systemFontOfSize:22]};
        
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder
                                                                     attributes:placeholderAttributes];
    }
}

-(void)showValidationMessage:(NSString *)warning {
    
    if(!self.warningLabel) {
        self.warningLabel = [self createWarningLabel];
        [self.superview addSubview:self.warningLabel];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.warningLabel.hidden = NO;
        self.warningLabel.text = warning;
    });
}

-(void)hideValidationMessage {
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.warningLabel) {
            self.warningLabel.hidden = YES;
        }
    });
}
@end

@implementation OPUITextView(PrivateMethods)

-(void)drawYellowBorder {
    
    [self drawLineFromPoint:self.bounds.origin
                    toPoint:CGPointMake(self.bounds.origin.x + self.bounds.size.width, self.bounds.origin.y)
                    ofColor:OPUIWhiteWithAlpha(0.5)];
    
    [self drawLineFromPoint:CGPointMake(self.bounds.origin.x, (self.bounds.origin.y + self.bounds.size.height - 1) )
                    toPoint:CGPointMake(self.bounds.origin.x + self.bounds.size.width, (self.bounds.origin.y + self.bounds.size.height - 1))
                    ofColor:OPUIWhiteWithAlpha(0.5)];
}

-(void)drawLineFromPoint:(CGPoint)startPoint
                 toPoint:(CGPoint)endPoint
                 ofColor:(UIColor *)color {
    CGRect rect = (CGRect) {
        .origin.x = startPoint.x ,
        .origin.y = startPoint.y ,
        .size.width  = fabs(endPoint.x - startPoint.x) ,
        .size.height = 1
    };
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
    
    CAShapeLayer *lineLayer = [[CAShapeLayer alloc] init];
    lineLayer.path  = path.CGPath;
    lineLayer.fillColor = color.CGColor;
    
    [self.layer addSublayer:lineLayer];
}

-(UILabel *)createWarningLabel {
    CGRect rect = (CGRect) {
        .origin.x = 34,
        .origin.y = self.frame.origin.y + self.bounds.size.height - 10 ,
        .size.width  = self.bounds.size.width ,
        .size.height = self.bounds.size.height
    };
    UILabel *warningLabel = [[UILabel alloc] initWithFrame:rect];
    warningLabel.font = OPUIFontSFRegularWithSize(12);
    warningLabel.textColor = OPUIYellowWithAlpha(1);
    return warningLabel;
}

@end

//
//  OPUITextField.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 20.10.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPUITextField.h"
#import "OPUICorporateColorUtils.h"

@interface OPUITextField()

/**
 The warning label placed under the text field
 */
@property (nonatomic) UILabel  *warningLabel;

@end

@interface OPUITextField(PrivateMethods)

/**
 Draws two lines above and below the text view
 */
-(void)drawYellowBorder;

/**
 Creates the image view with the warning icon

 @return The warning image view
 */
-(UIImageView *)createRightImageView;

/**
 Creates the label to display the warning

 @return The warning label
 */
-(UILabel *)createWarningLabel;

@end

@implementation OPUITextField

- (void)drawRect:(CGRect)rect {

    self.textColor = UIColor.whiteColor;
    self.tintColor = OPUIYellowWithAlpha(1);
    self.font = OPUIFontSFRegularWithSize(22);
    
    self.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 34, 5)];
    self.leftViewMode = UITextFieldViewModeAlways;
    
    [self drawYellowBorder];
    
    if(self.placeholder) {
        NSDictionary *placeholderAttributes = @{NSForegroundColorAttributeName:OPUIWhiteWithAlpha(0.5),
                                                            NSFontAttributeName:OPUIFontSFRegularWithSize(22)};
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder
                                                                     attributes:placeholderAttributes];
    }
}

-(void)showValidationMessage:(NSString *)warning{
    
    if(!self.rightView) {
        self.rightView = [self createRightImageView];
    }
    self.rightView.hidden = NO;
    self.rightViewMode = UITextFieldViewModeAlways;
    
    if(!self.warningLabel) {
        self.warningLabel = [self createWarningLabel];
        [self.superview addSubview:self.warningLabel];
    }
    self.warningLabel.hidden = NO;
    self.warningLabel.text = warning;
}

-(void)hideValidationMessage{
    
    if(self.warningLabel) {
        self.warningLabel.hidden = YES;
    }
    
    if(self.rightView) {
        self.rightView.hidden = YES;
    }
}

@end

@implementation OPUITextField(PrivateMethods)

-(void)drawYellowBorder{
    
    [self drawLineFromPoint:self.bounds.origin
                    toPoint:CGPointMake(self.bounds.origin.x + self.bounds.size.width, self.bounds.origin.y)
                    ofColor:OPUIWhiteWithAlpha(0.5)];
    
    [self drawLineFromPoint:CGPointMake(self.bounds.origin.x, (self.bounds.origin.y + self.bounds.size.height - 1) )
                    toPoint:CGPointMake(self.bounds.origin.x + self.bounds.size.width, (self.bounds.origin.y + self.bounds.size.height - 1))
                    ofColor:OPUIWhiteWithAlpha(0.5)];
}

-(void)drawLineFromPoint:(CGPoint)startPoint
                 toPoint:(CGPoint)endPoint
                 ofColor:(UIColor *)color{
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

-(UIImageView *)createRightImageView{
    CGRect rect = (CGRect) {
        .origin.x = 0 ,
        .origin.y = 0 ,
        .size.width  = self.bounds.size.height*1.3 ,
        .size.height = self.bounds.size.height
    };
    
    UIImageView *rightImageView = [[UIImageView alloc] initWithFrame:rect];
    
    rightImageView.image = [UIImage imageNamed:@"warning"];
    rightImageView.bounds = CGRectInset(self.rightView.frame, 7.0f, 7.0f);
    rightImageView.contentMode = UIViewContentModeScaleAspectFit;
    return rightImageView;
}

-(UILabel *)createWarningLabel{
    CGRect rect = (CGRect) {
        .origin.x = self.leftView.bounds.size.width ,
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



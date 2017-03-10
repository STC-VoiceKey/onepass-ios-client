//
//  OPUIBubbleProgressView.h
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 11.11.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OPUIBubbleProgressView : UIProgressView

@property (nonatomic) IBInspectable UIColor   *successColor;
@property (nonatomic) IBInspectable UIColor   *failColor;
@property (nonatomic) IBInspectable UIColor   *strokeColor;
@property (nonatomic) IBInspectable UIColor   *fillColor;
@property (nonatomic) IBInspectable float     bubbleRadius;
@end

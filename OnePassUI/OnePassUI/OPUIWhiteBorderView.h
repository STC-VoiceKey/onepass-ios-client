//
//  OPUIBorderedView.h
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 30.01.17.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Displays the white border around the view
 */
@interface OPUIWhiteBorderView : UIView

@property (nonatomic) IBInspectable UIColor *frameColor;
@property (nonatomic) IBInspectable CGFloat frameWidth;

@end

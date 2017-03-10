//
//  OPUIDigitLabel.h
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 07.11.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 The label splits the text into two lines(splits based on '\n').
 The first line displays by small font()
 */
@interface OPUIDigitLabel : UILabel

@property (nonatomic) IBInspectable UIColor  *firstLabelColor;
@property (nonatomic) IBInspectable UIColor  *secondLabelColor;


@end

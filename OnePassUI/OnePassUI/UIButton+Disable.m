//
//  UIButton+Disable.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 18.07.16.
//  Copyright © 2016 Soloshcheva Aleksandra. All rights reserved.
//

#import "UIButton+Disable.h"

@implementation UIButton (Disable)

-(void)setEnabled:(BOOL)enabled{
    [super setEnabled:enabled];
    
    self.alpha = enabled ? 1.0 : 0.3;
    
}

@end

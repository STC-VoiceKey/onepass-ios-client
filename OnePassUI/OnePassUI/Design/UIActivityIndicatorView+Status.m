//
//  UIActivityIndicatorView+Status.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 03.11.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "UIActivityIndicatorView+Status.h"

@implementation UIActivityIndicatorView (Status)

-(void)setActivityIndicatorStatus2Fail{
    self.tag = 1;
}

-(void)setActivityIndicatorStatus2Success{
    self.tag = 2;
}

-(void)resetActivityIndicatorStatus{
    self.tag = 0;
}
@end

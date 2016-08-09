//
//  OPUIProgressView.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 26.07.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPUIProgressView.h"

@implementation OPUIProgressView

- (instancetype)initWithProgressViewStyle:(UIProgressViewStyle)style{
    
    self = [super initWithProgressViewStyle:style];
    if( self )
    {
        [self setTrackImage:[UIImage imageNamed:@"progressBackground"
                                       inBundle:[NSBundle bundleForClass:[self class]]
                  compatibleWithTraitCollection:nil]];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if( self )
    {
        [self setTrackImage:[UIImage imageNamed:@"progressBackground"
                                       inBundle:[NSBundle bundleForClass:[self class]]
                  compatibleWithTraitCollection:nil]];
    }
    return self;
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if( self )
    {
        [self setTrackImage:[UIImage imageNamed:@"progressBackground"
                                       inBundle:[NSBundle bundleForClass:[self class]]
                  compatibleWithTraitCollection:nil]];
    }
    return self;
}

@end

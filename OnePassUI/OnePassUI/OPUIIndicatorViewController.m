//
//  OPUIIndicatorViewController.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 23.10.2018.
//  Copyright © 2018 Speech Technology Center. All rights reserved.
//

#import "OPUIIndicatorViewController.h"

#import "OPUIIndicatorImageView.h"

@interface OPUIIndicatorViewController ()

@property (nonatomic, weak) IBOutlet OPUIIndicatorImageView   *imageSingleFace;
@property (nonatomic, weak) IBOutlet OPUIIndicatorImageView   *imageFaceFound;
@property (nonatomic, weak) IBOutlet OPUIIndicatorImageView   *imageEyesFound;
@property (nonatomic, weak) IBOutlet OPUIIndicatorImageView   *imageBrightness;
@property (nonatomic, weak) IBOutlet OPUIIndicatorImageView   *imageTremor;

@end

@implementation OPUIIndicatorViewController

-(void)viewWillAppear:(BOOL)animated{
    [self offEyesClosedIndicator];
    [self offFaceOffCenterIndicator ];
    [self offManyFacesIndicator];
    [self offPureLightIndicator];
    [self offShackingIndicator];
    [super viewWillAppear:animated];
}

- (void)highlightEyesClosedIndicator {
    self.imageEyesFound.active = YES;
}

- (void)highlightFaceOffCenterIndicator {
    self.imageFaceFound.active = YES;
}

- (void)highlightManyFacesIndicator {
    self.imageSingleFace.active = YES;
}

- (void)highlightPureLightIndicator {
    self.imageBrightness.active = YES;
}

- (void)highlightShackingIndicator {
    self.imageTremor.active = YES;
}

- (void)offEyesClosedIndicator {
    self.imageEyesFound.active = NO;
}

- (void)offFaceOffCenterIndicator {
    self.imageFaceFound.active = NO;
}

- (void)offManyFacesIndicator {
    self.imageSingleFace.active = NO;
}

- (void)offPureLightIndicator {
    self.imageBrightness.active = NO;
}

- (void)offShackingIndicator {
    self.imageTremor.active = NO;
}

@end

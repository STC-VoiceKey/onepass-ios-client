//
//  OPCRPreviewView.m
//  OnePassCaptureResources
//
//  Created by Soloshcheva Aleksandra on 17.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPCRPreviewView.h"

@implementation OPCRPreviewView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

+ (Class)layerClass {
    return [AVCaptureVideoPreviewLayer class];
}

- (AVCaptureSession*)session
{
    return [(AVCaptureVideoPreviewLayer*)self.layer session];
}

- (void)setSession:(AVCaptureSession *)session
{
    [(AVCaptureVideoPreviewLayer*)self.layer setSession:session];
}

-(void)drawRect:(CGRect)rect{
    self.layer.borderWidth = 2;
    [self failBorder];
}

-(void)failBorder{
    self.layer.borderColor = [UIColor redColor].CGColor;
}

-(void)successBorder{
    self.layer.borderColor = [UIColor greenColor].CGColor;
}

//-(void)suspenseBorder{
//    self.layer.borderColor = [UIColor yellowColor].CGColor;
//}

@end

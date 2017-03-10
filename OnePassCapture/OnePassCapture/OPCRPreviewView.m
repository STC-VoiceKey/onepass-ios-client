//
//  OPCRPreviewView.m
//  OnePassCaptureStandard
//
//  Created by Soloshcheva Aleksandra on 17.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPCRPreviewView.h"

@implementation OPCRPreviewView

+ (Class)layerClass {
    return [AVCaptureVideoPreviewLayer class];
}

- (AVCaptureSession*)session{
    return [(AVCaptureVideoPreviewLayer*)self.layer session];
}

- (void)setSession:(AVCaptureSession *)session{
    [(AVCaptureVideoPreviewLayer*)self.layer setSession:session];
}

- (AVCaptureVideoPreviewLayer *)videoPreviewLayer{
    return (AVCaptureVideoPreviewLayer *)self.layer;
}

@end

//
//  OPCSCaptureIOSBaseManager.m
//  OnePassCaptureStandard
//
//  Created by Soloshcheva Aleksandra on 20.09.17.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import "OPCSCaptureIOSBaseManager.h"

@interface OPCSCaptureIOSBaseManager(PrivateMethods)

- (AVCaptureDeviceInput *)pickCamera;

@end

@implementation OPCSCaptureIOSBaseManager

- (void) setupCaptureDevice {
    [self.session beginConfiguration];
    
    NSArray* oldInputs = [self.session inputs];
    for (AVCaptureInput *oldInput in oldInputs)
        [self.session removeInput:oldInput];
    
    AVCaptureDeviceInput* input = [self pickCamera];
    if ( ! input ) {
        for (AVCaptureInput *oldInput in oldInputs) {
            [self.session addInput:oldInput];
        }
    } else {
        [self.session addInput:input];
        AVCaptureDevice  *device = input.device;
        
        NSError* err;
        if ( ! [device lockForConfiguration:&err] ) {
            NSLog(@"Could not lock device: %@",err);
        }
    }
    
    [self.session commitConfiguration];
}

@end

@implementation OPCSCaptureIOSBaseManager(PrivateMethods)

- (AVCaptureDeviceInput *)pickCamera {
    AVCaptureDevicePosition desiredPosition = AVCaptureDevicePositionFront;
    BOOL hadError = NO;
    for (AVCaptureDevice *device in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        if ([device position] == desiredPosition) {
            NSError *error = nil;
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
            if (error) {
                hadError = YES;
                //displayErrorOnMainQueue(error, @"Could not initialize for AVMediaTypeVideo");
            } else if ( [self.session canAddInput:input] ) {
                return input;
            }
        }
    }
    if ( ! hadError ) {
        //displayErrorOnMainQueue(nil, @"No camera found for requested orientation");
    }
    return nil;
}

@end

//
//  OPCSOSXCapturePhotoManager.m
//  OnePassCaptureStandard
//
//  Created by Soloshcheva Aleksandra on 30.08.17.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import "OPCSOSXCapturePhotoManager.h"
#import "CIImage+Extra.h"

@implementation OPCSOSXCapturePhotoManager

-(void)setupCaptureDevice {
    NSError *error = nil;
    
    for (AVCaptureDevice *device in AVCaptureDevice.devices) {
        if ([device hasMediaType:AVMediaTypeVideo] || [device hasMediaType:AVMediaTypeMuxed]) {
           
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
            if (error) {
                NSLog(@"deviceInputWithDevice failed with error %@", error.localizedDescription);
            }
            if ([self.session canAddInput:input]) {
                [self.session addInput:input];
            }
            break;
        }
    }
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection {
    [self checkPortraitFeatures:sampleBuffer];
}

@end

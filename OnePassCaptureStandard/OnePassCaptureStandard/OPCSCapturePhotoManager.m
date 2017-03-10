//
//  OPCSCaptureVideoManager.m
//  OnePassCaptureStandard
//
//  Created by Soloshcheva Aleksandra on 17.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPCSCapturePhotoManager.h"
#import <OnePassCapture/OnePassCapture.h>

#import "UIImage+Extra.h"

@interface OPCSCapturePhotoManager()<AVCaptureVideoDataOutputSampleBufferDelegate>

/**
 Represents the taken photo as JPEG
 */
@property( nonatomic, readwrite) NSData  *jpeg;

@end

@implementation OPCSCapturePhotoManager

#pragma mark - IOPCPhotoProtocol

-(void)takePicture{
    if (self.loadDataBlock)
    {
        if (self.jpeg)  self.loadDataBlock(self.jpeg, nil);
        else
        {
            self.loadDataBlock(nil, [NSError errorWithDomain:@"com.onepass.captureresource"
                                                        code:400
                                                    userInfo:@{ NSLocalizedDescriptionKey: @"Can't take a photo"}]);
        }
    }
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    [self checkEnviroment:sampleBuffer];
    [self checkPortraitFeatures:sampleBuffer];
 
    UIImage *image = [self imageFromSampleBuffer:sampleBuffer];

    UIImage *cuttedimage = [image correctImageOrientation:image];
    
    if ( UIDeviceOrientationIsLandscape( UIDevice.currentDevice.orientation) ) {
        cuttedimage = [cuttedimage scaledToSize:CGSizeMake(320, 240)];
    } else {
        cuttedimage = [cuttedimage scaledToSize:CGSizeMake(240, 320)];
    }
    
    self.jpeg  = UIImageJPEGRepresentation(cuttedimage, 0.9);
}



@end

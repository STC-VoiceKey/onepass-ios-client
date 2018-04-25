//
//  OPCSCaptureVideoManager.m
//  OnePassCaptureStandard
//
//  Created by Soloshcheva Aleksandra on 17.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPCSCapturePhotoManager.h"
#import <OnePassCapture/OnePassCapture.h>
#import <ImageIO/ImageIO.h>

#import "CIImage+Extra.h"
#import "NSObject+Resolution.h"

@interface OPCSCapturePhotoManager(PrivateMethods)

-(NSError *)errorCantTake;
-(CGSize)size;

@end

@implementation OPCSCapturePhotoManager

#pragma mark - IOPCPhotoProtocol

-(void)takePicture {
    if (self.loadImageBlock) {
        CIImage *sizedImage = [self.currentImage scaledToSize:self.size];
        
        if (sizedImage) {
            self.loadImageBlock(sizedImage, nil);
        } else {
            self.loadImageBlock(nil, self.errorCantTake);
        }
    }
}

@end

@implementation OPCSCapturePhotoManager(PrivateMethods)

-(NSError *)errorCantTake {
    return [NSError errorWithDomain:@"com.onepass.captureresource"
                               code:400
                           userInfo:@{ NSLocalizedDescriptionKey: @"Can't take a photo"}];
}

-(CGSize)size{
    if ([self isSmallResolution]) {
        return (self.isPortraitOrientation == OPCAvailableOrientationUp) ? CGSizeMake(240, 320) : CGSizeMake(320, 240);
    }
    
    return self.isPortraitOrientation ? CGSizeMake(640, 480) : CGSizeMake(480, 640);
}

@end

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
#warning move to plist
    return self.isPortraitOrientation ? CGSizeMake(320, 240) : CGSizeMake(240, 320);
}

@end

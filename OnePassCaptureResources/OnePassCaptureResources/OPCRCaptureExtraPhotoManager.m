//
//  OPCRCaptureDetailPhotoManager.m
//  OnePassCaptureResources
//
//  Created by Soloshcheva Aleksandra on 10.08.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPCRCaptureExtraPhotoManager.h"
#import "UIImage+Extra.h"
#import <ImageIO/ImageIO.h>


@interface OPCRCaptureExtraPhotoManager()

@property(nonatomic) BOOL isSingleFace;
@property(nonatomic) BOOL isFaceFound;
@property(nonatomic) BOOL isEyesFound;

@property(nonatomic) BOOL isBrightness;
@property(nonatomic) BOOL isNoTremor;

@property(nonatomic) CIFaceFeature* previousFace;

@end

@interface OPCRCaptureExtraPhotoManager(PrivateMethods)

-(void)calcBrightness:(CMSampleBufferRef)sampleBuffer;
-(void)calcTremor:(CIFaceFeature *)face;
@end

@implementation OPCRCaptureExtraPhotoManager

- (void) setupAVCapture
{
    [super setupAVCapture];
    
    self.isSingleFace = NO;
    self.isFaceFound  = NO;
    self.isEyesFound  = NO;
    
    self.isBrightness = NO;
    self.isNoTremor = NO;
    
    [self update];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{

    
    UIImage *image = [self imageFromSampleBuffer:sampleBuffer];
    
    [self calcBrightness:sampleBuffer];

    CIImage *ciImage = [CIImage imageWithCGImage:image.CGImage];
    
    CIDetector* detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                              context:nil
                                              options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    
    NSArray* features = [detector featuresInImage:ciImage options:@{CIDetectorEyeBlink:@YES}];
    
    if (features.count == 1)
    {
        if(!self.isFaceFound)
            self.isFaceFound = YES;
        
        if(!self.isSingleFace)
            self.isSingleFace = YES;
        

        for(CIFaceFeature* faceFeature in features)
        {
            [self calcTremor:faceFeature];
            if (faceFeature.hasLeftEyePosition && faceFeature.hasRightEyePosition) {
                if(!self.isEyesFound)
                    self.isEyesFound = YES;
                
                if (!faceFeature.leftEyeClosed && !faceFeature.rightEyeClosed) {
                    if(!self.isEyesFound)
                        self.isEyesFound = YES;
                }
                else
                {
                    if(self.isEyesFound)
                        self.isEyesFound = NO;
                }
            }
            else    if(self.isEyesFound)
                    self.isEyesFound = NO;
        }
    }
    else
    {
        if (features.count == 0) {
            if(self.isFaceFound)
            {
                self.isFaceFound = NO;
                self.previousFace = nil;
            }
        }
        
        if (features.count > 1) {
            if(self.isSingleFace)
            {
                self.isSingleFace = NO;
                self.previousFace = nil;
            }
        }
    }

    if(self.isReady!=( self.isEyesFound && self.isSingleFace && self.isFaceFound))
        [self setupIsReady:( self.isEyesFound && self.isSingleFace && self.isFaceFound)];
    
    if (self.isReady)
    {
        UIImage *imageToDisplay = [UIImage imageWithCGImage:[image CGImage]
                                                      scale:[image scale]
                                                orientation:UIImageOrientationUpMirrored];
        
        self.image = [imageToDisplay scaledToSize:CGSizeMake(240, 320)];
        
        self.jpeg  = UIImageJPEGRepresentation(self.image, 0.9);
    }
//    else
//    {
//        if (self.image)
//            self.image = nil;
//        
//        if (self.jpeg)
//            self.jpeg = nil;
//    }

}

@end



@implementation OPCRCaptureExtraPhotoManager(PrivateMethods)

-(void)calcBrightness:(CMSampleBufferRef)sampleBuffer{
    
    CFDictionaryRef metadataDict = CMCopyDictionaryOfAttachments(NULL,
                                                                 sampleBuffer, kCMAttachmentMode_ShouldPropagate);
    NSDictionary *metadata = [[NSMutableDictionary alloc]
                              initWithDictionary:(__bridge NSDictionary*)metadataDict];
    CFRelease(metadataDict);
    NSDictionary *exifMetadata = [[metadata objectForKey:(NSString *)kCGImagePropertyExifDictionary] mutableCopy];
    float brightnessValue = [[exifMetadata objectForKey:(NSString *)kCGImagePropertyExifBrightnessValue] floatValue];
    if (brightnessValue < 0)
    {
        if (self.isBrightness)
            self.isBrightness = NO;
    }
    else
    {
        if (!self.isBrightness)
            self.isBrightness = YES;
    }
}

-(void)calcTremor:(CIFaceFeature *)face{
    
    if (self.previousFace)
    {
        if (face.hasLeftEyePosition && face.hasRightEyePosition)
        {
            float x = face.bounds.origin.x + face.bounds.size.width/2;
            float y = face.bounds.origin.y + face.bounds.size.height/2;
            
            CGPoint faceCenter = CGPointMake(x, y);
            
            x = self.previousFace.bounds.origin.x + self.previousFace.bounds.size.width/2;
            y = self.previousFace.bounds.origin.y + self.previousFace.bounds.size.height/2;
            
            CGPoint prevFaceCenter = CGPointMake(x, y);
            
            float delta = sqrt(pow(faceCenter.x - prevFaceCenter.x, 2) + pow(faceCenter.y - prevFaceCenter.y, 2));
            
            if (delta > 10){
                if (!self.isNoTremor) self.isNoTremor = YES;
            }
            else{
                if (self.isNoTremor) self.isNoTremor = NO;
            }
        }
    }
    
    self.previousFace = face;

}
@end

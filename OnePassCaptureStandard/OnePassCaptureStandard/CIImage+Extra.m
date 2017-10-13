//
//  CIImage+Extra.m
//  OnePassCaptureStandard
//
//  Created by Soloshcheva Aleksandra on 21.08.17.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import "CIImage+Extra.h"

@implementation CIImage (Extra)

- (CIImage *)scaledToSize:(CGSize)newSize{
    CIFilter *filter = [CIFilter filterWithName:@"CILanczosScaleTransform"];
    
    [filter setValue:self forKey:@"inputImage"];
    
    float scale = newSize.width / self.extent.size.width;
    [filter setValue:@(scale) forKey:@"inputScale"];
    [filter setValue:@(1.0) forKey:@"inputAspectRatio"];
    
    CIImage *result = [filter valueForKey:@"outputImage"];
    
    return result;
}

-(CIImage *)correctImageOrientation {
#warning Check image orientation
    return self;
}

@end

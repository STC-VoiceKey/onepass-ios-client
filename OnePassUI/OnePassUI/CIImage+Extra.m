//
//  CIImage+Extra.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 16.11.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import "CIImage+Extra.h"

@implementation CIImage (Extra)

-(NSData *)nsData {
    return  UIImageJPEGRepresentation(self.uiImage, 0.9);
}

-(UIImage *)uiImage {
    CIContext *ciContext = [CIContext contextWithOptions:nil];
    CGImageRef cgImageRef = [ciContext createCGImage:self fromRect:self.extent];
    
    UIImage *nsImage = [UIImage imageWithCGImage:cgImageRef];
    
    CGImageRelease(cgImageRef);
    return nsImage;
}
/*
 UIImage *uiImage = [self imageCI2UI:ciImage];
 return  UIImageJPEGRepresentation(uiImage, 0.9);
 */

-(UIImage *)imageCI2UI:(CIImage *)ciImage{
    CIContext *ciContext = [CIContext contextWithOptions:nil];
    CGImageRef cgImageRef = [ciContext createCGImage:ciImage fromRect:ciImage.extent];
    
    UIImage *nsImage = [UIImage imageWithCGImage:cgImageRef];
    
    CGImageRelease(cgImageRef);
    return nsImage;
}
@end

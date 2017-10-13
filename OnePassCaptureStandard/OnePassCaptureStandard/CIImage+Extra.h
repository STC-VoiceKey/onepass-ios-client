//
//  CIImage+Extra.h
//  OnePassCaptureStandard
//
//  Created by Soloshcheva Aleksandra on 21.08.17.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import <CoreImage/CoreImage.h>

@interface CIImage (Extra)
/**
 Re-scales an image to a new size
 
 @param newSize The new image size
 @return The image in the new size
 */
- (CIImage *)scaledToSize:(CGSize)newSize;


/**
 Corrects the orientation of image
 
 @param image The source image
 @return The corrected image
 */
-(CIImage *)correctImageOrientation;

@end

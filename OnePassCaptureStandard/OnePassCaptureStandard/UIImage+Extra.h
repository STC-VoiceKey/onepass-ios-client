//
//  UIImage+Extra.h
//  OnePassCaptureStandard
//
//  Created by Soloshcheva Aleksandra on 21.07.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 The category with additional functionality for image processing
 */
@interface UIImage (Extra)

/**
 Fixes orientation problems

 @return The properly oriented image
 */
- (UIImage *)fixOrientation;

/**
 Converts an image to a black and white image

 @return The black and white image
 */
- (UIImage *)convertImageToGrayScale;

/**
 Re-scales an image to a new size

 @param newSize The new image size
 @return The image in the new size
 */
- (UIImage *)scaledToSize:(CGSize)newSize;

/**
 Crops the image by the rectangle

 @param rect The rectangle
 @return Tne result image
 */
-(UIImage *)cropImageWithRect:(CGRect)rect;

/**
 Rotates the image on the angle

 @param radians The angle of rotation in radians
 @return The rotated image
 */
-(UIImage *)rotateImageWithRadians:(double)radians;

/**
 Corrects the orientation of image

 @param image The source image
 @return The corrected image
 */
-(UIImage *)correctImageOrientation:(UIImage *)image;

@end

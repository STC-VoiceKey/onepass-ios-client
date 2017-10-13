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
 Re-scales an image to a new size

 @param newSize The new image size
 @return The image in the new size
 */
- (UIImage *)scaledToSize:(CGSize)newSize;

/**
 Corrects the orientation of image

 @param image The source image
 @return The corrected image
 */
-(UIImage *)correctImageOrientation:(UIImage *)image;

@end

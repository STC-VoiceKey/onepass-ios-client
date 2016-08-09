//
//  UIImage+Extra.h
//  OnePassCaptureResources
//
//  Created by Soloshcheva Aleksandra on 21.07.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extra)

- (UIImage *)convertImageToGrayScale;
- (UIImage *)scaledToSize:(CGSize)newSize;

@end
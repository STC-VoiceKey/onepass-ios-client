//
//  OPCRCaptureVideoManager.h
//  OnePassCaptureResources
//
//  Created by Soloshcheva Aleksandra on 17.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "OPCRCaptureManager.h"

@interface OPCRCapturePhotoManager : OPCRCaptureManager

@property(nonatomic,readonly) UIImage *image;
@property(nonatomic,readonly) NSData  *jpeg;

@end

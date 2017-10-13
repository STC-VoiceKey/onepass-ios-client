//
//  IOPCLoadingImageProtocol.h
//  OnePassCapture
//
//  Created by Soloshcheva Aleksandra on 01.09.17.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreImage/CoreImage.h>

/**
 Is the block which is called when the image is received
 
 @param image The recieved image
 @param error Data receiving error.
 */
typedef void (^LoadImageBlock) ( CIImage *image, NSError *error);

/**
 The loading image protocol
 */
@protocol IOPCLoadingImageProtocol <NSObject>

/**
 Setter for 'LoadDataBlock' The block called when the data is ready
 @param block The block called when the data is ready
 */
-(void)setLoadImageBlock:(LoadImageBlock)block;

/**
 Getter for 'LoadDataBlock'
 @return The block
 */
-(LoadImageBlock)loadImageBlock;

@end

//
//  IOPCPhotoProtocol.h
//  OnePassCapture
//
//  Created by Soloshcheva Aleksandra on 09.08.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 The 'IOPCPhotoProtocol' takes a photo
 */
@protocol IOPCPhotoProtocol <NSObject>


/**
 Takes a photo
 */
-(void)takePicture;

@end

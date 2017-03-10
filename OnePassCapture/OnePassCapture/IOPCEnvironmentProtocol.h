//
//  IOPCEnvironmentProtocol.h
//  OnePassCapture
//
//  Created by Soloshcheva Aleksandra on 12.08.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 The 'IOPCEnvironmentProtocol' analyses and provides a state of brightness and clearness of the source picture
 */
@protocol IOPCEnvironmentProtocol <NSObject>

@required

/**
 Shows that the brightness of the picture is enough or not
 
 @return YES, if the source of the photo is bright enough
 */
-(BOOL)isBrightness;

/**
 Shows that the device or the face is shaking and the source of the picture is not clear
 
 @return YES, if the photo has acceptable clearness
 */
-(BOOL)isNoTremor;

@end

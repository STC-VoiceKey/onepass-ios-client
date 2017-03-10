//
//  IOPCPortraitFeaturesProtocol.h
//  OnePassCapture
//
//  Created by Soloshcheva Aleksandra on 11.08.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 The 'IOPCPortraitFeaturesProtocol' analyses and provides the state of the portrait features in the source picture
 */
@protocol IOPCPortraitFeaturesProtocol <NSObject>

@required

/**
 Shows if there is one face in the source picture

 @return YES, if there is one face
          NO, if other faces are detected
 */
-(BOOL)isSingleFace;

/**
 Shows if the face was detected in the frame

 @return  YES, if the face was detected
 */
-(BOOL)isFaceFound;

/**
 Shows that two eyes are found and opened

 @return YES, if eyes are detected
 */
-(BOOL)isEyesFound;

@end

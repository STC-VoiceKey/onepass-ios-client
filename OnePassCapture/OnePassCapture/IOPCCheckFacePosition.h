//
//  ICheckFacePosition.h
//  OnePassCapture
//
//  Created by Soloshcheva Aleksandra on 18.05.17.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Checking that the face is suitable
 */
@protocol IOPCCheckFacePosition <NSObject>

@optional

-(BOOL)isSuitableFaceByRightEye:(CGPoint)rightEye
                      byLeftEye:(CGPoint)leftEye
                         inSize:(CGSize)size;

@end

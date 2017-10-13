//
//  OPCSFaceManager.h
//  OnePassCaptureStandard
//
//  Created by Soloshcheva Aleksandra on 18.05.17.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OnePassCapture/OnePassCapture.h>

/**
 * Anchor points for a frame
 */
typedef struct {
    CGPoint leftBottomPoint;
    CGPoint rightTopPoint;
} OPCSFaceBoundPoint;

/**
 *  The external and interior frames for the face position check
 */
typedef struct {
    OPCSFaceBoundPoint external;
    OPCSFaceBoundPoint interior;
} OPCSFaceBounds;

/**
 * Checking that the face is suitable
 */
@interface OPCSFaceManager : NSObject<IOPCCheckFacePosition,IOPCInterfaceOrientationProtocol>

@end

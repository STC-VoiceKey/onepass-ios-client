//
//  IOPCInterfaceOrientationProtocol.h
//  OnePassCapture
//
//  Created by Soloshcheva Aleksandra on 21.08.17.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    OPCAvailableOrientationUp,
    OPCAvailableOrientationRight,
    OPCAvailableOrientationLeft
} OPCAvailableOrientation;//Available interface orientation

/**
 Provides checking interface orientation
 */
@protocol IOPCInterfaceOrientationProtocol <NSObject>

@required
/**
 Sets current interface orientatio

 @param orientation The interface orientation
 */
-(void)setInterfaceOrientation:(OPCAvailableOrientation)orientation;

/**
 @return Checking orientation is portrait
 */
-(BOOL)isPortraitOrientation;

@end

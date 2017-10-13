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
} OPCAvailableOrientation;

@protocol IOPCInterfaceOrientationProtocol <NSObject>

@required

-(void)setInterfaceOrientation:(OPCAvailableOrientation)orientation;
-(BOOL)isPortraitOrientation;

@end

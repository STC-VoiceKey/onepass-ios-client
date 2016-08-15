//
//  IsIOPCRCaptureManager.h
//  OnePassUICommon
//
//  Created by Soloshcheva Aleksandra on 09.08.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IOPCRCaptureManager.h"

@protocol IsIOPCRCaptureManager <NSObject>
@required
-(void)setCaptureManager:(id<IOPCRCaptureManager>)captureManager;
-(id<IOPCRCaptureManager>)captureManager;
@end

//
//  OPCRCaptureManager.h
//  OnePassCaptureResources
//
//  Created by Soloshcheva Aleksandra on 08.08.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OnePassUICommon/OnePassUICommon.h>

@interface OPCRCaptureResourceManager : NSObject<IOPCRCaptureManager>

+(id<IOPCRCaptureManager>)sharedInstance;

@end

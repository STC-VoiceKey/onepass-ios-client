//
//  IOPCRCaptureManager.h
//  OnePassCaptureResources
//
//  Created by Soloshcheva Aleksandra on 08.08.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <OnePassUICommon/OPCRPreviewView.h>

#import "IOPCRCaptureVideoManager.h"
#import "IOPCRCaptureVoiceManager.h"
#import "IOPCRCapturePhotoManager.h"

@protocol IOPCRCaptureManager <NSObject>

@required
-(id<IOPCRCaptureVideoManager>)videoManager;
-(id<IOPCRCaptureVoiceManager>)voiceManager;
-(id<IOPCRCapturePhotoManager>)photoManager;


@end

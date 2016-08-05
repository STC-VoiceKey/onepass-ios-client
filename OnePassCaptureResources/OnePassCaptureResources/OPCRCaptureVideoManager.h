//
//  OPCRVideoCaptureManager.h
//  OnePassCaptureResources
//
//  Created by Soloshcheva Aleksandra on 27.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <OnePassCaptureResources/OnePassCaptureResources.h>
#import "OPCRCaptureManager.h"

typedef void (^LoadVideoBlock) ( NSData *data, NSError *error);

@interface OPCRCaptureVideoManager : OPCRCaptureManager

@property (nonatomic) LoadVideoBlock resultBlock;

@property (nonatomic,readonly) BOOL isRecording;
-(void)record;
-(void)stop;
-(UIImage *)thumbnail;
@end

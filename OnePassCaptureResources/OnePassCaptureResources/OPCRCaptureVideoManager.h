//
//  OPCRVideoCaptureManager.h
//  OnePassCaptureResources
//
//  Created by Soloshcheva Aleksandra on 27.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <OnePassUICommon/OnePassUICommon.h>
#import "OPCRCaptureBaseManager.h"

@interface OPCRCaptureVideoManager : OPCRCaptureBaseManager<IOPCRCaptureVideoManager>

@property (nonatomic) LoadDataBlock loadDataBlock;

@property (nonatomic,readonly) BOOL isRecording;
-(void)record;
-(void)stop;
-(UIImage *)thumbnail;
@end

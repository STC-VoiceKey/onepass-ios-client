//
//  OPCRCaptureVideoManager.h
//  OnePassCaptureResources
//
//  Created by Soloshcheva Aleksandra on 17.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <OnePassUICommon/OnePassUICommon.h>
#import "OPCRCaptureBaseManager.h"

@interface OPCRCapturePhotoManager : OPCRCaptureBaseManager<IOPCRCapturePhotoManager>

@property(nonatomic,readwrite) UIImage *image;
@property(nonatomic,readwrite) NSData  *jpeg;

@property (nonatomic) LoadDataBlock loadDataBlock;

-(void)takePicture;

- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer;

@end

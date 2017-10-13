//
//  OPCSCaptureVideoManager.h
//  OnePassCaptureStandard
//
//  Created by Soloshcheva Aleksandra on 17.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <OnePassCapture/OnePassCapture.h>
#import "OPCSCaptureIOSBaseManager.h"

/**
 Provides the photo resource 
 */
@interface OPCSCapturePhotoManager : OPCSCaptureIOSBaseManager<IOPCCapturePhotoManagerProtocol,
                                                            IOPCPortraitFeaturesProtocol,
                                                            IOPCEnvironmentProtocol>
/**
  Is implementation of 'IOPCLoadingDataProtocol'
 */
@property (nonatomic) LoadImageBlock loadImageBlock;

/**
 Is implementation of 'IOPCPhotoProtocol'
 */
-(void)takePicture;

@end

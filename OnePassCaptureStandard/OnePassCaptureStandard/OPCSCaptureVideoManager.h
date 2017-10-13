//
//  OPCRVideoCaptureManager.h
//  OnePassCaptureStandard
//
//  Created by Soloshcheva Aleksandra on 27.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <OnePassCapture/OnePassCapture.h>
#import "OPCSCaptureIOSBaseManager.h"

/**
 Provides the video resource.
 Checks the portrait features and enviroment before the start of recording.
 
 @warning There is a visual problem with AVCaptureSession outputs switching.
 If an output is changed to another one, the device display turns dark and the picture appears again after about 0.5 seconds.
 So it is necessary to call -showSnapshot: and -hideSnapshot: methods to patch it
 */
@interface OPCSCaptureVideoManager : OPCSCaptureIOSBaseManager<IOPCCaptureVideoManagerProtocol,
                                                            IOPCPortraitFeaturesProtocol,
                                                            IOPCEnvironmentProtocol,
                                                            IOPCSnapshotProtocol,
                                                            IOPCInterfaceOrientationProtocol>

/**
 Is implementation of 'IOPCLoadingDataProtocol'
 */
@property (nonatomic) LoadDataBlock     loadDataBlock;

/**
 Is implementation of 'IOPCCaptureVideoManagerProtocol'
 */
@property (nonatomic) Ready2RecordBlock ready2RecordBlock;
-(void)prepare2record;

/**
 The view that is shown between switching outputs of AVCaptureSession
 
 @warning It is nessesary because there is a moment when the display turns dark during the outputs switching
 */
@property (nonatomic,readonly) CIImage   *snapshot;

/**
 Is implementation of 'IOPCRecordProtocol'
 */
@property (nonatomic,readonly) BOOL isRecording;
-(void)record;
-(void)stop;

@end

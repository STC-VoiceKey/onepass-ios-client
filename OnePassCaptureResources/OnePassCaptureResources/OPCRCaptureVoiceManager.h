//
//  OPCRCaptureVoiceManager.h
//  OnePassCaptureResources
//
//  Created by Soloshcheva Aleksandra on 22.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OnePassUICommon/OnePassUICommon.h>
#import "OPCRCaptureBaseManager.h"

@interface OPCRCaptureVoiceManager : NSObject<IOPCRCaptureVoiceManager>

@property(nonatomic) NSUInteger *passphraseNumber;
@property (nonatomic,copy) LoadDataBlock loadDataBlock;

@property(nonatomic) BOOL isRecording;

-(void)record;
-(void)stop;

@end

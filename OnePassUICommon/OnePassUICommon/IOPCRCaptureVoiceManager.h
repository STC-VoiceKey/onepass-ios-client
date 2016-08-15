//
//  IOPCRCaptureVoiceManager.h
//  OnePassCaptureResources
//
//  Created by Soloshcheva Aleksandra on 08.08.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IOPCRRecord.h"
#import "IOPCRLoadData.h"
#import "IOPCRVoice.h"


@protocol IOPCRCaptureVoiceManager <IOPCRRecord,
                                    IOPCRLoadData,
                                    IOPCRVoice>

@end

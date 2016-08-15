//
//  IOPCRCapturePhotoManager.h
//  OnePassCaptureResources
//
//  Created by Soloshcheva Aleksandra on 08.08.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IOPCRPhoto.h"
#import "IOPCRLoadData.h"
#import "IOPCRSession.h"
#import "IOPCRPortraitFeatures.h"
#import "IOPCREnvironment.h"


@protocol IOPCRCapturePhotoManager <IOPCRPhoto,
                                    IOPCRLoadData,
                                    IOPCRSession,
                                    IOPCRPortraitFeatures,
                                    IOPCREnvironment>
@end

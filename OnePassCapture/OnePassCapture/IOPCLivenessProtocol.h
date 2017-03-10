//
//  ILiveness.h
//  OnePassCapture
//
//  Created by Soloshcheva Aleksandra on 29.08.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IOPCVoiceProtocol.h"

/**
 The 'IOPCLivenessProtocol' provides the necessary data for verification,
 if the liveness data is calculated on the device
 
 @warning You can use this method, only if you use FaceSDK on the device.
 */
@protocol IOPCLivenessProtocol <NSObject>

@required

/**
 Trasfers the passphrase
 
 @param passphrase The passphrase
 */
-(void)setPasshrase:(NSString *)passPhrase;

/**
 The image data as jpeg
 */
-(NSData *)jpeg;

/**
 The voice features (VSDK)
 */
-(NSData *)voiceFeatures;

/**
 The LD features (FaceSDK)
 */
-(NSData *)ldFeatures;

@end

//
//  OPCRCaptureVoiceManager.h
//  OnePassCaptureResources
//
//  Created by Soloshcheva Aleksandra on 22.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^LoadVoiceBlock) ( NSData *data, NSError *error);

@interface OPCRCaptureVoiceManager : NSObject

-(id)initWithPassphraseNumber:(NSUInteger) passphrase withResultBlock:(LoadVoiceBlock)block;

-(void)record;
-(void)stop;

@end

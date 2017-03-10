//
//  IOPCVoiceProtocol.h
//  OnePassCapture
//
//  Created by Soloshcheva Aleksandra on 09.08.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 The 'IOPCVoiceProtocol' provides the ordinal number of the passphrase
 */
@protocol IOPCVoiceProtocol <NSObject>

@required
/**
 Sets the passphrase ordinal number
 
 @param number The ordinal number of the passphrase
 */
-(void)setPassphraseNumber:(NSNumber *)number;

@end

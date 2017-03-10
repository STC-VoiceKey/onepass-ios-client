//
//  IOPCAcousticStopProtocol.h
//  OnePassCapture
//
//  Created by Soloshcheva Aleksandra on 27.09.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 The 'IOPCAcousticStopProtocol' analyses the source of the voice and checks that the passphrase was pronounced
 */
@protocol IOPCAcousticStopProtocol <NSObject>

@required

/**
 Starts analysing the source of the voice

 @param pass The passphrase to be detected
 */
-(void)startWithPassphrase:(NSString *)pass;

/**
 Says if the passphrase was pronounced

 @param bytes The buffer containing the source of the voice
 @param length The size of the voice buffer
 @return YES, if the passphrase was pronounced
 */
-(BOOL)isSayingFinished:(const void *)bytes length:(NSUInteger)length;

/**
 Stops analysing the source of the voice
 */
-(void)stopListening;

@end

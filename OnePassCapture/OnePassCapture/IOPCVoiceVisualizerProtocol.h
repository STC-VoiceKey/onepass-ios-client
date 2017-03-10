//
//  IOPCVoiceVisualizerProtocol.h
//  OnePassCapture
//
//  Created by Soloshcheva Aleksandra on 31.10.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 The 'IOPCVoiceVisualizerProtocol' transfers the voice data to be represented in the visual form
 */

@protocol IOPCVoiceVisualizerProtocol <NSObject>

@required

/**
 Updates the visual representation of the voice
 
 @param bytes The buffer containing the source of the voice
 @param length The size of the voice buffer
*/
-(void)visualizeVoiceBuffer:(const void *)bytes
                     length:(NSUInteger)length;

@end

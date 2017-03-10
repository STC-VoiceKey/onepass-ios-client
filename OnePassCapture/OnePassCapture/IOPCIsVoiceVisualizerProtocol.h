//
//  IOPCVoiceVisualizerProtocol.h
//  OnePassCapture
//
//  Created by Soloshcheva Aleksandra on 28.10.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IOPCVoiceVisualizerProtocol.h"

/**
 Sets the instance of 'IOPCVoiceVisualizerProtocol'
 */
@protocol IOPCIsVoiceVisualizerProtocol <NSObject>

/**
 Setter for 'IOPCVoiceVisualizerProtocol'
 */
-(void)setPreview:(id<IOPCVoiceVisualizerProtocol>)preview;
      
@end

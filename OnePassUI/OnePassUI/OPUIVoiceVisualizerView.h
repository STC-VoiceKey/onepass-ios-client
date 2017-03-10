//
//  OPUIVoiceVisualizerView.h
//  OnePassUICommon
//
//  Created by Soloshcheva Aleksandra on 28.10.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OnePassCapture/OnePassCapture.h>

/**
 The view displays the voice wave in the visual form
 */
@interface OPUIVoiceVisualizerView : UIView<IOPCVoiceVisualizerProtocol>

/**
 The color of the voice wave
 */
@property (nonatomic) IBInspectable UIColor *waveColor;

@end

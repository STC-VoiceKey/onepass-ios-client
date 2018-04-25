//
//  OPUIEnrollFaceCaptureViewController.h
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 14.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OPUIRotatableViewController.h"

#import "OPUIEnrollFaceViewProtocol.h"

/**
 Displays the video stream in the view and captures the face picture
 */
@interface OPUIEnrollFaceViewController : OPUIRotatableViewController<OPUIEnrollFaceViewProtocol>

@end

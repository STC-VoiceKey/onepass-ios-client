//
//  OPUIVerifyFacePresenter.h
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 15.11.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OPUIVerifyFacePresenterProtocol.h"
#import <OnePassCapture/OnePassCapture.h>
#import "OPUIVerifyFaceViewProtocol.h"

@interface OPUIVerifyFacePresenter : NSObject<OPUIVerifyFacePresenterProtocol>

@property id<OPUIVerifyFaceViewProtocol> view;

-(void)stopPhotoManager;

@end

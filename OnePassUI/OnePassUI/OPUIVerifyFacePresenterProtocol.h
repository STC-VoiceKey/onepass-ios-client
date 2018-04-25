//
//  OPUIVerifyFacePresenterProtocol.h
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 22.11.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OPUIVerifyFaceViewProtocol.h"

@protocol OPUIVerifyFacePresenterProtocol <NSObject>

-(void)attachView:(id<OPUIVerifyFaceViewProtocol>)view;
-(void)deattachView;

-(void)didCancel;
-(void)didOrientationChanged:(OPCAvailableOrientation)currentOrientation;

@end

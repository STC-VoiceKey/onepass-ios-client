//
//  OPUIEnrollFacePresenterProtocol.h
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 22.11.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OPUIEnrollFaceViewProtocol.h"

#import <OnePassCore/OnePassCore.h>
#import <OnePassCapture/OnePassCapture.h>

@protocol OPUIEnrollFacePresenterProtocol <NSObject>

-(void)attachView:(id<OPUIEnrollFaceViewProtocol>)view;
-(void)deattachView;

-(void)setPhotoCaptureManager:(id<IOPCCapturePhotoManagerProtocol,
                               IOPCPortraitFeaturesProtocol,
                               IOPCEnvironmentProtocol,
                               IOPCInterfaceOrientationProtocol>)photoCaptureManager;

-(void)setService:(id<IOPCTransportProtocol>)service;

-(void)setPreviewView:(id<IOPCPreviewView>)preview;

-(void)onCancel;

-(void)didOrientationChanged:(OPCAvailableOrientation)currentOrientation;
-(void)didStable;

@end

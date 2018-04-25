//
//  OPUIVefifyFaceViewProtocol.h
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 22.11.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <OnePassCore/OnePassCore.h>
#import <OnePassCapture/OnePassCapture.h>

#import "OPUIActivityViewProtocol.h"

@protocol OPUIVerifyFaceViewProtocol <OPUIActivityViewProtocol>

-(void)showFacePositionHelper;
-(void)hideFacePositionHelper;

-(void)highlightEyesClosedIndicator;
-(void)highlightManyFacesIndicator;
-(void)highlightFaceOffCenterIndicator;
-(void)highlightPureLightIndicator;
-(void)highlightShackingIndicator;

-(void)offEyesClosedIndicator;
-(void)offManyFacesIndicator;
-(void)offFaceOffCenterIndicator;
-(void)offPureLightIndicator;
-(void)offShackingIndicator;

-(id<IOPCPreviewView>)previewView;

-(id<IOPCTransportProtocol>)service;

-(id<IOPCCapturePhotoManagerProtocol,
  IOPCPortraitFeaturesProtocol,
  IOPCEnvironmentProtocol,
  IOPCInterfaceOrientationProtocol>)photoCaptureManager;

-(NSString *)user;

-(void)exit;
-(void)showError:(NSError *)error;
-(void)routeToPageWithError:(NSError *)error;

@end

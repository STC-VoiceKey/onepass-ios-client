//
//  OPUIEnrollFaceViewProtocol.h
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 22.11.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreImage/CoreImage.h>

#import "OPUIActivityViewProtocol.h"

@protocol OPUIEnrollFaceViewProtocol <OPUIActivityViewProtocol>

-(void)showError:(NSError *)error;

-(void)routeToVoicePage;
-(void)routeToStaticVoicePage;

-(void)exit;

-(NSData *)dataFromCIImage:(CIImage *)ciImage;

-(void)stopIndicatorObserving;

-(void)disableCancel;
-(void)enableCancel;


@end

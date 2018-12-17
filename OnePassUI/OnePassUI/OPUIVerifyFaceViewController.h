//
//  OPUIVerifyByFaceViewController.h
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 15.11.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OPUIVerifyFaceViewProtocol.h"
#import "OPUIIndicatorViewController.h"

#import "OPUIVerifyFacePresenterProtocol.h"

@interface OPUIVerifyFaceViewController : OPUIIndicatorViewController<OPUIVerifyFaceViewProtocol>

@property (nonatomic) id<OPUIVerifyFacePresenterProtocol> presenter;

-(void)attachView;

@end

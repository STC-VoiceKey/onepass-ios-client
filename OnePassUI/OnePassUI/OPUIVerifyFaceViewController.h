//
//  OPUIVerifyByFaceViewController.h
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 15.11.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OPUIVerifyFaceViewProtocol.h"
#import "OPUIRotatableViewController.h"

@interface OPUIVerifyFaceViewController : OPUIRotatableViewController<OPUIVerifyFaceViewProtocol>
-(void)attachView;
@end

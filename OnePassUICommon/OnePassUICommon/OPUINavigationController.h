//
//  OPUINavigationController.h
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 20.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OnePassCore/OnePassCore.h>
#import "IOPCRCaptureManager.h"
#import "IsIOPCRCaptureManager.h"

@interface OPUINavigationController : UINavigationController<ITransportService,IsIOPCRCaptureManager>

@property (nonatomic,strong) id<ITransport> service;
@property (nonatomic,strong) id<IOPCRCaptureManager> captureManager;

@end

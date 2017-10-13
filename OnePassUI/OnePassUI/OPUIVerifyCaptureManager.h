//
//  OPUIVerifyCaptureManager.h
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 28.12.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <OnePassCapture/OnePassCapture.h>
#import <OnePassCore/OnePassCore.h>



@interface OPUIVerifyCaptureManager : NSObject<IOPCRecordProtocol,
                                                IOPCNoisyProtocol,
                                              IOPCSessionProtocol>

/**
 The 'IOPCTransportProtocol' implementation
 */
@property (nonatomic, weak)    id<IOPCTransportProtocol>           service;

/**
 The verification session
 */
@property (nonatomic, weak)    id<IOPCVerificationSessionProtocol> session;

/*
 The activity indicator
 */
@property (nonatomic, weak)    UIActivityIndicatorView *activityIndicator;

/**
 Is the block which is called when data is received
 */
@property (nonatomic) ResponceBlock responceBlock;

/**
 The manager of capture verification resources
 */
@property (nonatomic, strong) id<IOPCCaptureVideoManagerProtocol> videoCaptureManager;

/**
 The passphrase
 */
@property (nonatomic) NSString *passphrase;

@end

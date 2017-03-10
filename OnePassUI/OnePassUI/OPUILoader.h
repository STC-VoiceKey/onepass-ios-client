//
//  STCUILoader.h
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 14.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "IOPUILoaderProtocol.h"

/**
 The instance of 'IOPUILoaderProtocol'.
 */
@interface OPUILoader : NSObject<IOPUILoaderProtocol>

///---------------------------
/// @name Initialization
///---------------------------

/**
 The shared default instance of `IOPUILoaderProtocol` initialized with default values.
 */
+(id<IOPUILoaderProtocol>)sharedInstance;

@end

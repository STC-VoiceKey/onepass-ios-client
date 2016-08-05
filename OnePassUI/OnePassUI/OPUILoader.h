//
//  STCUILoader.h
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 14.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "STCUILoaderProtocol.h"

@interface OPUILoader : NSObject<STCUILoaderProtocol>

+ (id<STCUILoaderProtocol>)sharedInstance;



@end

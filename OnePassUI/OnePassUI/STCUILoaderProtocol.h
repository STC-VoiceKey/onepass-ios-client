//
//  STCUILoaderProtocol.h
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 14.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OnePassCore/OnePassCore.h>

@protocol STCUILoaderProtocol <NSObject>

@required
-(UIViewController *)enrollUILoadWithService:(id<ITransport>) service;
-(UIViewController *)verifyUILoadWithService:(id<ITransport>) service;
@end

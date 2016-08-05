//
//  OPCOManager.h
//  OnePassCoreOnline
//
//  Created by Soloshcheva Aleksandra on 15.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OnePassCore/OnePassCore.h>

@interface OPCOManager : NSObject<ITransport>

@property (nonatomic,readonly) BOOL isHostAccessable;
@property (nonatomic,readonly) BOOL isInternetAccessable;

@end

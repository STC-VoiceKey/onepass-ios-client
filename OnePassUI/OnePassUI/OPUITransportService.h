//
//  OPUITransportService.h
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 23.11.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <OnePassCore/OnePassCore.h>

@interface OPUITransportService : NSObject

@property (nonatomic) id<IOPCTransportProtocol> service;

-(id)initWithService:(id<IOPCTransportProtocol>)service;

@end

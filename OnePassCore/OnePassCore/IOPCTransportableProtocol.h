//
//  IOPCTransportableProtocol.h
//  OnePassCore
//
//  Created by Soloshcheva Aleksandra on 20.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IOPCTransportProtocol.h"

/**
 Provides access to the transport service implementation of 'IOPCTransportProtocol'
 Has the getter and the setter, so can be used as a property
 Should be used to transfer a transport service between entities
 */
@protocol IOPCTransportableProtocol <NSObject>

@required

/**
 Setter for 'IOPCTransportProtocol'
 @param service Instance of 'IOPCTransportProtocol'
 */
-(void)setService:(id<IOPCTransportProtocol>) service;

/**
 Getter for 'IOPCTransportProtocol'
 @return Instance of 'IOPCTransportProtocol'
 */
-(id<IOPCTransportProtocol>)service;

@end

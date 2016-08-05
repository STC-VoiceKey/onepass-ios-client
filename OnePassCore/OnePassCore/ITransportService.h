//
//  ITransportService.h
//  OnePassCore
//
//  Created by Soloshcheva Aleksandra on 20.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Itransport.h"

@protocol ITransportService <NSObject>
@required
-(void)setService:(id<ITransport>) service;
-(id<ITransport>)service;
@end

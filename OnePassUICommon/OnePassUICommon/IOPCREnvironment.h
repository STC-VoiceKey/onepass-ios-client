//
//  IOPCREnvironment.h
//  OnePassUICommon
//
//  Created by Soloshcheva Aleksandra on 12.08.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IOPCREnvironment <NSObject>

@required

-(BOOL)isBrightness;
-(BOOL)isNoTremor;

@end

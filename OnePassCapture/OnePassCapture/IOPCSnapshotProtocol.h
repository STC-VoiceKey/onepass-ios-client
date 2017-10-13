//
//  IOPCSnapshotProtocol.h
//  OnePassCapture
//
//  Created by Soloshcheva Aleksandra on 23.08.17.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IOPCSnapshotProtocol <NSObject>

-(CIImage *)snapshot;

@end

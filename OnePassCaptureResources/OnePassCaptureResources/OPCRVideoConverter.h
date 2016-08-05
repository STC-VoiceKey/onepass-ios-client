//
//  OPCRVideoConverter.h
//  OnePassCaptureResources
//
//  Created by Soloshcheva Aleksandra on 27.07.16.
//  Copyright © 2016 Soloshcheva Aleksandra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OPCRVideoConverter : NSObject

-(id)initWithAssetURL:(NSURL *)url toOutputURL:(NSURL *)outputURL;

- (void)exportAsynchronouslyWithCompletionHandler:(void (^)(NSError *error))handler;

@end

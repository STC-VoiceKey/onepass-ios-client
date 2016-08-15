//
//  IOPCRRecord.h
//  OnePassCaptureResources
//
//  Created by Soloshcheva Aleksandra on 08.08.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IOPCRRecord <NSObject>

-(BOOL)isRecording;

-(void)record;
-(void)stop;

@end

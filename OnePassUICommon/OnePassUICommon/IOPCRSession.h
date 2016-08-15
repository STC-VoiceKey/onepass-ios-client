//
//  IOPCRSession.h
//  OnePassCaptureResources
//
//  Created by Soloshcheva Aleksandra on 09.08.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OnePassUICommon/OPCRPreviewView.h>

@protocol IOPCRSession <NSObject>

@required
-(BOOL)readyForCapture;

-(void)setPreview:(OPCRPreviewView *)preview;

-(void)startRunning;
-(void)stopRunning;
@end

//
//  NSObject+ResourceAccessUtils.h
//  OnePassOnlineDemo
//
//  Created by Soloshcheva Aleksandra on 26.09.17.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ResourceAccessUtils)

-(BOOL)isMicrophoneAvailable;
-(BOOL)isCameraAvailable;

-(BOOL)isMicrophoneUndetermined;
-(BOOL)isCameraUndetermined;

-(void)askCameraPermissionWithHandler:(void (^)(BOOL granted))handler;                                                                                         
-(void)askMicPermissionWithHandler:(void (^)(BOOL granted))handler;

@end

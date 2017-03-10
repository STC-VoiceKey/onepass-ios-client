//
//  UIViewController+ResourceAccessUtils.h
//  OnePassOnlineDemo
//
//  Created by Soloshcheva Aleksandra on 17.02.17.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ResourceAccessUtils)

-(BOOL)isMicrophoneAvailable;
-(BOOL)isCameraAvailable;

-(BOOL)isMicrophoneUndetermined;
-(BOOL)isCameraUndetermined;

-(void)askCameraPermission;
-(void)askMicPermission;

@end

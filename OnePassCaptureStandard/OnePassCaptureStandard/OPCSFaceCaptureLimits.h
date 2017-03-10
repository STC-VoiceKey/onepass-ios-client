//
//  OPCSFaceCaptureLimits.h
//  OnePassCaptureStandard
//
//  Created by Soloshcheva Aleksandra on 02.02.17.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface OPCSFaceLimit : NSObject

@property(nonatomic) float widthLimit;
@property(nonatomic) float upHeightLimit;
@property(nonatomic) float downHeightLimit;

-(id)initWithWidthLimit:(float)widthLimit
      withUpHeightLimit:(float)upHeightLimit
    withDownHeightLimit:(float)downHeightLimit;
    
@end

@interface OPCSFaceCaptureLimits : NSObject

@property (nonatomic) BOOL isCaptured;

-(OPCSFaceLimit *)limit;

-(BOOL)checkFace:(CGRect)face
        inScreen:(CGRect)screen;

@end

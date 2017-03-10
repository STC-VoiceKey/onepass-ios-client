//
//  OPCSFaceCaptureLimits.m
//  OnePassCaptureStandard
//
//  Created by Soloshcheva Aleksandra on 02.02.17.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import "OPCSFaceCaptureLimits.h"

@implementation OPCSFaceLimit

-(id)initWithWidthLimit:(float)widthLimit
      withUpHeightLimit:(float)upHeightLimit
    withDownHeightLimit:(float)downHeightLimit{
    self = [super init];
    if (self) {
        self.widthLimit      = widthLimit;
        self.upHeightLimit   = upHeightLimit;
        self.downHeightLimit = downHeightLimit;
    }
    return self;
}

-(NSString *)debugDescription{
    return  [NSString stringWithFormat:@"widthLimit = %f upHeightLimit=%f downHeightLimit=%f", _widthLimit, _upHeightLimit, _downHeightLimit];
}

@end

@interface OPCSFaceCaptureLimits()

@property(nonatomic) OPCSFaceLimit *portraitCaptureLimit;
@property(nonatomic) OPCSFaceLimit *portraitLostLimit;
@property(nonatomic) OPCSFaceLimit *landscapeCaptureLimit;
@property(nonatomic) OPCSFaceLimit *landscapeLostLimit;

@end

@interface OPCSFaceCaptureLimits(PrivateMethods)

-(BOOL)isWidthLimitPassedForFace:(CGRect)face inScreen:(CGRect)screen;
-(BOOL)isHeigthLimitPassedForFace:(CGRect)face inScreen:(CGRect)screen;
-(BOOL)isCenterLimitPassedForFace:(CGRect)face inScreen:(CGRect)screen;

@end

@implementation OPCSFaceCaptureLimits

-(id)init{
    self = [super init];
    if (self) {
        self.portraitCaptureLimit = [[OPCSFaceLimit alloc] initWithWidthLimit:0.65 withUpHeightLimit:0.15 withDownHeightLimit:0.90];
        self.portraitLostLimit    = [[OPCSFaceLimit alloc] initWithWidthLimit:0.50 withUpHeightLimit:0.10 withDownHeightLimit:0.85];

        self.landscapeCaptureLimit = [[OPCSFaceLimit alloc] initWithWidthLimit:0.30 withUpHeightLimit:0.10 withDownHeightLimit:0.95];
        self.landscapeLostLimit    = [[OPCSFaceLimit alloc] initWithWidthLimit:0.25 withUpHeightLimit:0.05 withDownHeightLimit:0.90];
    }
    return self;
}

-(OPCSFaceLimit *)limit{

    if (UIDeviceOrientationIsPortrait(UIDevice.currentDevice.orientation)) {
        if (self.isCaptured) {
            return self.portraitCaptureLimit;
        } else {
            return self.portraitLostLimit;
        }
    } else {
        if (self.isCaptured) {
            return self.landscapeCaptureLimit;
        } else {
            return self.landscapeLostLimit;
        }
    }
}

-(BOOL)checkFace:(CGRect)face inScreen:(CGRect)screen{

    if ((UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) && (UIDeviceOrientationIsLandscape(UIDevice.currentDevice.orientation))) {
        if(![self isCenterLimitPassedForFace:face inScreen:screen]){
            return NO;
        }
    }
    
    if([self isWidthLimitPassedForFace:face inScreen:screen]) {
        if ([self isHeigthLimitPassedForFace:face inScreen:screen]) {
            return YES;
        }
    }
    
    return NO;
}

@end

@implementation OPCSFaceCaptureLimits(PrivateMethods)

-(BOOL)isWidthLimitPassedForFace:(CGRect)face inScreen:(CGRect)screen{
    float deltaWidthPercent = face.size.width/screen.size.width;
    return (deltaWidthPercent > self.limit.widthLimit);
}

-(BOOL)isHeigthLimitPassedForFace:(CGRect)face inScreen:(CGRect)screen{
    float yUp   = face.origin.y;
    float yDown = face.origin.y + face.size.height;
    /*  float lowHeightLimit  = (self.isCaptured ? 0.10 : 0.15)*height;
        float highHeightLimit = (self.isCaptured ? 0.90 : 0.85)*height;
        if ( (y1 > lowHeightLimit) && ( y2 < highHeightLimit ) )*/
//    NSLog(@"screen = (%f %f) (%f %f)", screen.origin.x, screen.origin.y, screen.size.width,screen.size.height);
//    
//    NSLog(@"yUp = %f",yUp);
//    NSLog(@"yDown = %f",yDown);
//    
//    NSLog(@"upHeightLimit = %f",self.limit.upHeightLimit*screen.size.height);
//    NSLog(@"downHeightLimit = %f",self.limit.downHeightLimit*screen.size.height);
    return  ((yUp > self.limit.upHeightLimit*screen.size.height) && (yDown < self.limit.downHeightLimit*screen.size.height) );
}

-(BOOL)isCenterLimitPassedForFace:(CGRect)face inScreen:(CGRect)screen{
    
    CGPoint faceCenter   = CGPointMake( face.size.width/2 + face.origin.x, face.size.height/2 + face.origin.y);
    CGPoint screenCenter = CGPointMake( screen.size.width/2, screen.size.height/2);

    CGFloat distance = sqrtf( powf(screenCenter.x - faceCenter.x, 2) + powf(screenCenter.y - faceCenter.y, 2));

    return (distance < 50);
}

@end

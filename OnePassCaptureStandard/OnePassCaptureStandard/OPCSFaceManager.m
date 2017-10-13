//
//  OPCSFaceManager.m
//  OnePassCaptureStandard
//
//  Created by Soloshcheva Aleksandra on 18.05.17.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import "OPCSFaceManager.h"
#import <CoreGraphics/CoreGraphics.h>

@interface OPCSFaceManager()

@property OPCSFaceBounds percentBoundsPortrait;
@property OPCSFaceBounds percentBoundsLandscape;

@property (readonly) OPCSFaceBounds percentBounds;

@property (nonatomic) OPCAvailableOrientation interfaceOrientation;

@end

@interface OPCSFaceManager(PrivateMethods)

-(OPCSFaceBoundPoint)faceRectBasedOnRightEye:(CGPoint)rightEye
                                   onLeftEye:(CGPoint)leftEye;

-(OPCSFaceBounds)boundsWithExternalBounds:(OPCSFaceBoundPoint)externalBoundPoints
                       withExternalBounds:(OPCSFaceBoundPoint)interiorBoundPoints;

-(OPCSFaceBoundPoint)boundsWithLeftBottomPoint:(CGPoint)leftBottomPoint
                             withRightTopPoint:(CGPoint)rightTopPoint;

-(OPCSFaceBounds)calculatedBoundsFromSize:(CGSize)size;

-(BOOL)checkFace:(OPCSFaceBoundPoint)face
        inBounds:(OPCSFaceBounds)bounds;
@end

@implementation OPCSFaceManager

-(id)init {
    self = [super init];
    if (self) {
        OPCSFaceBoundPoint externalPercentPoints = [self boundsWithLeftBottomPoint:CGPointMake(0.05, 0.15)
                                                                 withRightTopPoint:CGPointMake(0.95, 0.85)];
        OPCSFaceBoundPoint interiorPercentPoints = [self boundsWithLeftBottomPoint:CGPointMake(0.30, 0.30)
                                                                 withRightTopPoint:CGPointMake(0.70, 0.70)];
        _percentBoundsPortrait = [self boundsWithExternalBounds:externalPercentPoints withExternalBounds:interiorPercentPoints];
        
        externalPercentPoints  = [self boundsWithLeftBottomPoint:CGPointMake(0.25, 0.10)
                                               withRightTopPoint:CGPointMake(0.75, 0.90)];
        interiorPercentPoints  = [self boundsWithLeftBottomPoint:CGPointMake(0.35, 0.25)
                                               withRightTopPoint:CGPointMake(0.65, 0.75)];
        _percentBoundsLandscape = [self boundsWithExternalBounds:externalPercentPoints withExternalBounds:interiorPercentPoints];
        
    }
    return self;
}

-(OPCSFaceBounds)percentBounds {
    return self.isPortraitOrientation ? _percentBoundsPortrait: _percentBoundsLandscape;
}

-(BOOL)isSuitableFaceByRightEye:(CGPoint)rightEye
                      byLeftEye:(CGPoint)leftEye
                         inSize:(CGSize)size {
    
    OPCSFaceBoundPoint face = [self faceRectBasedOnRightEye:rightEye onLeftEye:leftEye];
    
    OPCSFaceBounds bounds = [self calculatedBoundsFromSize:size];
    
    return [self checkFace:face inBounds:bounds];
}

-(BOOL)isPortraitOrientation{
    return (_interfaceOrientation == OPCAvailableOrientationUp);
}

@end

@implementation OPCSFaceManager(PrivateMethods)

-(OPCSFaceBoundPoint)faceRectBasedOnRightEye:(CGPoint)rightEye onLeftEye:(CGPoint)leftEye {
    
    CGFloat centerX = leftEye.x + (rightEye.x - leftEye.x)/2;
    CGFloat centerY = leftEye.y + (rightEye.y - leftEye.y)/2;
    
    CGPoint center = CGPointMake(centerX, centerY);
    
    CGFloat eyesDistantion = sqrtf( powf( (rightEye.x - leftEye.x), 2.0) + powf( (rightEye.y - leftEye.y), 2.0)) ;
    
    OPCSFaceBoundPoint faceBoundPoint;
    faceBoundPoint.leftBottomPoint = CGPointMake(center.x - eyesDistantion, center.y - 1.75*eyesDistantion);
    faceBoundPoint.rightTopPoint   = CGPointMake(center.x + eyesDistantion, center.y + eyesDistantion);
    
    return faceBoundPoint;
}

-(OPCSFaceBoundPoint)boundsWithLeftBottomPoint:(CGPoint)leftBottomPoint
                             withRightTopPoint:(CGPoint)rightTopPoint{
    OPCSFaceBoundPoint boundPoint;
    boundPoint.leftBottomPoint = leftBottomPoint;
    boundPoint.rightTopPoint   = rightTopPoint;
    
    return boundPoint;
}

-(OPCSFaceBounds)boundsWithExternalBounds:(OPCSFaceBoundPoint)externalBoundPoints
                       withExternalBounds:(OPCSFaceBoundPoint)interiorBoundPoints {
    OPCSFaceBounds bounds ;
    bounds.external = externalBoundPoints;
    bounds.interior = interiorBoundPoints;
    
    return bounds;
}

-(OPCSFaceBounds)calculatedBoundsFromSize:(CGSize)size {
    OPCSFaceBounds bounds;
    
    CGPoint eLBPoint = CGPointMake(self.percentBounds.external.leftBottomPoint.x*size.width, self.percentBounds.external.leftBottomPoint.y*size.height);
    CGPoint eRBPoint = CGPointMake(self.percentBounds.external.rightTopPoint.x*size.width,   self.percentBounds.external.rightTopPoint.y*size.height);
    
    bounds.external = [self boundsWithLeftBottomPoint:eLBPoint withRightTopPoint:eRBPoint];
    
    CGPoint iLBPoint = CGPointMake(self.percentBounds.interior.leftBottomPoint.x*size.width, self.percentBounds.interior.leftBottomPoint.y*size.height);
    CGPoint iRBPoint = CGPointMake(self.percentBounds.interior.rightTopPoint.x*size.width,   self.percentBounds.interior.rightTopPoint.y*size.height);
    
    bounds.interior = [self boundsWithLeftBottomPoint:iLBPoint withRightTopPoint:iRBPoint];
    
    return bounds;
}

-(BOOL)checkFace:(OPCSFaceBoundPoint)face inBounds:(OPCSFaceBounds)bounds {
    
    if ( (face.leftBottomPoint.x > bounds.external.leftBottomPoint.x) && (face.leftBottomPoint.x < bounds.interior.leftBottomPoint.x) ) {
        
        if ( (face.leftBottomPoint.y > bounds.external.leftBottomPoint.y) && (face.leftBottomPoint.y < bounds.interior.leftBottomPoint.y) ) {
            
            if ( (face.rightTopPoint.x > bounds.interior.rightTopPoint.x) && (face.rightTopPoint.x < bounds.external.rightTopPoint.x) ) {
                
                if ( (face.rightTopPoint.y > bounds.interior.rightTopPoint.y) && (face.rightTopPoint.y < bounds.external.rightTopPoint.y)) {
                    
                    return YES;
                }
            }
        }
    }
    
    return NO;
    
}
@end

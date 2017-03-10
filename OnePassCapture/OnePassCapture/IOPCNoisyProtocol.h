//
//  IOPCNoisyProtocol.h
//  OnePassCapture
//
//  Created by Soloshcheva Aleksandra on 04.10.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 The checks a level of noise
 */
@protocol IOPCNoisyProtocol <NSObject>

@required

/**
 Shows that the level of noise is acceptable

 @return YES, is level of nois is acceptable
 */
-(BOOL)isNoNoisy;

/**
 Starts noise analysing
 */
-(void)startNoiseAnalyzer;

/**
 Stops noise analysing
 */
-(void)stopNoiseAnalyzer;

@optional

/**
 The current noise value
 */
-(NSNumber *)noiseValue;

@end

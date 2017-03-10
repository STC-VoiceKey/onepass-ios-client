//
//  OPCSVideoConverter.h
//  OnePassCaptureStandard
//
//  Created by Soloshcheva Aleksandra on 27.07.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Converts the video format to the another one with the preset quality
 Based on @see https://github.com/rs/SDAVAssetExportSession/
 
 @warning Uses QuickTime movie files 320x240(240x320) H.264 Linear PCM
*/

@interface OPCSVideoConverter : NSObject

///-------------------------------------------------------
///     @name Initialization
///-------------------------------------------------------
/**
 Initializes the instance of the video converter

 @param url The URL of the file to be converted
 @param outputURL The URL of the converted file
 @return The newly-initialized instance
 */
-(id)initWithAssetURL:(NSURL *)url
          toOutputURL:(NSURL *)outputURL;

/**
 Starts exporting asynchronously

 @param handler The block is called after the export is finished
 */
- (void)exportAsynchronouslyWithCompletionHandler:(void (^)(NSError *error))handler;

@end

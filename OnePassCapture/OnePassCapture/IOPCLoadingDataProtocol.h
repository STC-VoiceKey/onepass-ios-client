//
//  IOPCLoadingDataProtocol.h
//  OnePassCaptureStandard
//
//  Created by Soloshcheva Aleksandra on 08.08.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Is the block which is called when the data is received
 
 @param data The recieved data
 @param error Data receiving error.
 */
typedef void (^LoadDataBlock) ( NSData *data, NSError *error);

/**
 The loading data protocol
 */
@protocol IOPCLoadingDataProtocol <NSObject>

/**
 Setter for 'LoadDataBlock' The block called when the data is ready
 @param block The block called when the data is ready
 */
-(void)setLoadDataBlock:(LoadDataBlock)block;

/**
 Getter for 'LoadDataBlock'
 @return The block
 */
-(LoadDataBlock)loadDataBlock;

@end

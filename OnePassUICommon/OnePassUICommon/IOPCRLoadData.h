//
//  IOPCRLoadData.h
//  OnePassCaptureResources
//
//  Created by Soloshcheva Aleksandra on 08.08.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^LoadDataBlock) ( NSData *data, NSError *error);

@protocol IOPCRLoadData <NSObject>

-(void)setLoadDataBlock:(LoadDataBlock)block;
-(LoadDataBlock)loadDataBlock;

@end

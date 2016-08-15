//
//  IOPCRPortraitFeatures.h
//  OnePassUICommon
//
//  Created by Soloshcheva Aleksandra on 11.08.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IOPCRPortraitFeatures <NSObject>

@required

-(BOOL)isSingleFace;
-(BOOL)isFaceFound;
-(BOOL)isEyesFound;

@end

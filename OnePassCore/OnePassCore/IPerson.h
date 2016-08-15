//
//  IPerson.h
//  OnePassCore
//
//  Created by Soloshcheva Aleksandra on 15.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IPerson <NSObject>

@required
-(NSString *)userID;
-(BOOL)isFullEnroll;

@end

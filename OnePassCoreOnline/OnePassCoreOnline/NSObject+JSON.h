//
//  NSObject+JSON.h
//  OpePassOnlineDemo
//
//  Created by Soloshcheva Aleksandra on 17.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Category provides to serialize the object as JSON
 */
@interface NSObject (JSON)

/**
 Serializes itself as JSON

 @return The JSON string
 */
- (NSString*) JSONString;

@end

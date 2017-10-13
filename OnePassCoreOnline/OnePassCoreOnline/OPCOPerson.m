//
//  OPCOPerson.m
//  OnePassCoreOnline
//
//  Created by Soloshcheva Aleksandra on 15.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPCOPerson.h"

@implementation OPCOPerson

-(id)init{
    self = [super init];
    if (self) {
        _isFullEnroll = NO;
    }
    return self;
}

-(id)initWithJSON:(NSDictionary *)json {
    self = [self init];
    if (self) {
        self.userID       = json[@"id"];
        
        self.isFullEnroll = NO;
        
        NSInteger validModelCount = 0 ;
        for (NSDictionary *model in json[@"models"]) {
            
            if ([model[@"type"] isEqualToString:@"FACE_STC"] && ([model[@"samplesCount"] integerValue]==1) ) {
                validModelCount++;
            }
            
            if ([model[@"type"] isEqualToString:@"DYNAMIC_VOICE_KEY"] && ([model[@"samplesCount"] integerValue]==3) ) {
                validModelCount++;
            }
        }
        
        if (validModelCount == 2) {
            self.isFullEnroll = YES;
        }
        
    }
    return self;
}

@end

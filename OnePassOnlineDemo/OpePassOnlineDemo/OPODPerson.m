//
//  OPODPerson.m
//  OnePassOnlineDemo
//
//  Created by Soloshcheva Aleksandra on 14.11.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import "OPODPerson.h"
#import <OnePassUI/OnePassUI.h>

@interface OPODPerson()

@property (nonatomic) id<IOPUIModalitiesManagerProtocol> modalitiesManager;

@end

@implementation OPODPerson

-(id)init{
    self = [super init];
    if (self) {
        _isFullEnroll = NO;
        _modalitiesManager = [[OPUIModalitiesManager alloc] init];
    }
    return self;
}

-(id)initWithJSON:(NSDictionary *)json {
    self = [self init];
    if (self) {
        self.userID = json[@"id"];
        self.isFullEnroll = NO;

        if(self.modalitiesManager.modalityState == OPUIModalitiesStateFaceOnly) {
            self.isFullEnroll = [self isFullEnrollOnlyFaceOn:json];
        }
        
        if(self.modalitiesManager.modalityState == OPUIModalitiesStateVoiceOnly) {
            self.isFullEnroll = [self isFullEnrollOnlyVoiceOn:json];
        }
        
        if( (self.modalitiesManager.modalityState != OPUIModalitiesStateVoiceOnly) &&
            (self.modalitiesManager.modalityState != OPUIModalitiesStateFaceOnly) )  {
            self.isFullEnroll = [self isFullEnrollForAllModalities:json];
        }
    }
    return self;
}

-(BOOL)isFullEnrollOnlyFaceOn:(NSDictionary *)json {
    for (NSDictionary *model in json[@"models"]) {
        if ([model[@"type"] isEqualToString:@"FACE_STC"] && ([model[@"samplesCount"] integerValue]==1) ) {
            return YES;
        }
    }
    return NO;
}

-(BOOL)isFullEnrollOnlyVoiceOn:(NSDictionary *)json {
     for (NSDictionary *model in json[@"models"]) {
         if ([model[@"type"] isEqualToString:@"DYNAMIC_VOICE_KEY"] && ([model[@"samplesCount"] integerValue]==3) ) {
             return YES;
         }
     }
    return NO;
}

-(BOOL)isFullEnrollForAllModalities:(NSDictionary *)json {
    
    NSUInteger count = 0;
    
    for (NSDictionary *model in json[@"models"]) {
        if ([model[@"type"] isEqualToString:@"FACE_STC"] && ([model[@"samplesCount"] integerValue]==1) ) {
            count++;
        }
        
        if ([model[@"type"] isEqualToString:@"DYNAMIC_VOICE_KEY"] && ([model[@"samplesCount"] integerValue]==3) ) {
            count++;
        }
    }
    
    return (count==2) ? YES : NO;
}

@end

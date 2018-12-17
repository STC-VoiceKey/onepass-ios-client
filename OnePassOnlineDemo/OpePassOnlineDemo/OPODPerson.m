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
            return self;
        }
        
        if(self.modalitiesManager.modalityState == OPUIModalitiesStateVoiceOnly) {
            self.isFullEnroll = [self isFullEnrollOnlyVoiceOn:json];
            return self;
        }
        
        if(self.modalitiesManager.modalityState == OPUIModalitiesStateStaticVoiceOnly) {
            self.isFullEnroll = [self isFullEnrollOnlyStaticVoiceOn:json];
            return self;
        }
        
        if (self.modalitiesManager.modalityState == OPUIModalitiesStateFaceAndStaticVoice) {
            self.isFullEnroll = [self isFullEnrollForFaceAndStaticVoiceModalities:json];
            return self;
        }
        
        if (self.modalitiesManager.modalityState == OPUIModalitiesStateFaceAndVoice) {
            self.isFullEnroll = [self isFullEnrollForFaceAndVoiceModalities:json];
            return self;
        }
        
        if (self.modalitiesManager.modalityState == OPUIModalitiesStateFaceAndVoiceWithLiveness) {
            self.isFullEnroll = [self isFullEnrollForFaceAndVoiceModalities:json];
            return self;
        }
    }
    return self;
}

-(BOOL)isFullEnrollOnlyFaceOn:(NSDictionary *)json {
    for (NSDictionary *model in json[@"models"]) {
        if ([model[@"type"] isEqualToString:@"FACE_STC"] && ([model[@"samples_count"] integerValue]==1) ) {
            return YES;
        }
    }
    return NO;
}

-(BOOL)isFullEnrollOnlyVoiceOn:(NSDictionary *)json {
     for (NSDictionary *model in json[@"models"]) {
         if ([model[@"type"] isEqualToString:@"DYNAMIC_VOICE_KEY"] && ([model[@"samples_count"] integerValue]==3) ) {
             return YES;
         }
     }
    return NO;
}

-(BOOL)isFullEnrollOnlyStaticVoiceOn:(NSDictionary *)json {
    for (NSDictionary *model in json[@"models"]) {
        if ([model[@"type"] isEqualToString:@"STATIC_VOICE_KEY"] && ([model[@"samples_count"] integerValue]==3) ) {
            return YES;
        }
    }
    return NO;
}

-(BOOL)isFullEnrollForFaceAndVoiceModalities:(NSDictionary *)json {
    return [self isFullEnrollOnlyFaceOn:json] && [self isFullEnrollOnlyVoiceOn:json];
}

-(BOOL)isFullEnrollForFaceAndStaticVoiceModalities:(NSDictionary *)json {
    return [self isFullEnrollOnlyFaceOn:json] && [self isFullEnrollOnlyStaticVoiceOn:json];
}

@end

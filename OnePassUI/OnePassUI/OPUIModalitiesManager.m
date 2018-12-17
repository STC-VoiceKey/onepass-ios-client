//
//  OPUIModalitiesManager.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 10.11.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import "OPUIModalitiesManager.h"

@interface OPUIModalitiesManager()

@property (nonatomic) NSDictionary *defaultModalities;

@end

@implementation OPUIModalitiesManager

-(id)init {
    
    self = [super init];
    if (self) {
        NSDictionary *usersModalities   = [NSUserDefaults.standardUserDefaults objectForKey:@"kOnePassModalities_v32"];
        NSDictionary *defaultModalities = [NSBundle.mainBundle objectForInfoDictionaryKey:@"Modalities"];
        
        self.defaultModalities = (usersModalities != nil) ? usersModalities : defaultModalities;
    }
    return self;
    
}

#pragma mark - IOPUIModalitiesManagerProtocol
- (BOOL)isFaceOn {
    return [[self.defaultModalities objectForKey:@"face"] boolValue];
}

- (BOOL)isLivenessOn {
    return [[self.defaultModalities objectForKey:@"liveness"] boolValue];
}

- (BOOL)isVoiceOn {
    return [[self.defaultModalities objectForKey:@"voice"] boolValue];
}

- (BOOL)isStaticVoiceOn {
    return [[self.defaultModalities objectForKey:@"staticVoice"] boolValue];
}

-(OPUIModalitiesStates)modalityState {
    if (self.isFaceOn && self.isVoiceOn) {
        return (self.isLivenessOn) ? OPUIModalitiesStateFaceAndVoiceWithLiveness : OPUIModalitiesStateFaceAndVoice;
    }
    
    if (self.isFaceOn & !self.isVoiceOn & !self.isStaticVoiceOn) {
        return OPUIModalitiesStateFaceOnly;
    }
    
    if (!self.isFaceOn & self.isVoiceOn & !self.isStaticVoiceOn) {
        return OPUIModalitiesStateVoiceOnly;
    }
    
    if (!self.isFaceOn & !self.isVoiceOn & self.isStaticVoiceOn) {
        return OPUIModalitiesStateStaticVoiceOnly;
    }
    
    if (self.isFaceOn & !self.isVoiceOn & self.isStaticVoiceOn) {
        return OPUIModalitiesStateFaceAndStaticVoice;
    }
    
    return OPUIModalitiesStateNone;
}

@end



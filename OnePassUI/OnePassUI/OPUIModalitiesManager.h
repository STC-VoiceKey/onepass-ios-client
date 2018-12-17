//
//  OPUIModalitiesManager.h
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 10.11.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    OPUIModalitiesStateNone,
    OPUIModalitiesStateFaceOnly,
    OPUIModalitiesStateVoiceOnly,
    OPUIModalitiesStateStaticVoiceOnly,
    OPUIModalitiesStateFaceAndVoice,
    OPUIModalitiesStateFaceAndVoiceWithLiveness,
    OPUIModalitiesStateFaceAndStaticVoice
} OPUIModalitiesStates;

@protocol IOPUIModalitiesManagerProtocol

-(OPUIModalitiesStates)modalityState;

-(BOOL)isFaceOn;
-(BOOL)isVoiceOn;
-(BOOL)isStaticVoiceOn;
-(BOOL)isLivenessOn;

@end

@interface OPUIModalitiesManager : NSObject<IOPUIModalitiesManagerProtocol>

@end

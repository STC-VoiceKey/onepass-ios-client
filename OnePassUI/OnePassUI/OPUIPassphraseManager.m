//
//  OPUIEnrollPhraseManager.m
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 10.11.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//
#import <OnePassCore/OnePassCore.h>

#import "OPUIPassphraseManager.h"

@interface OPUIPassphraseManager ()

@property (nonatomic,assign) NSUInteger numberOfSample;

/**
 The manager for creating and controlling the passphrase
 */
@property (nonatomic) OPCPassphraseManager *passphraseManager;

/**
 Keeps the randomized digits sequence
 */
@property (nonatomic) NSArray<NSString*> *randomDigits;

@end

@implementation OPUIPassphraseManager

- (id)initWithNumberOfSample:(NSUInteger)sample {
    self = [super init];
    if (self) {
        self.passphraseManager = [OPCPassphraseManager sharedInstance];
        self.numberOfSample = sample;
    }
    return self;
}

- (id)init{
    self = [super init];
    if (self) {
        self.passphraseManager = [OPCPassphraseManager sharedInstance];
    }
    return self;
}

-(NSString *)digitSequence{
    switch (self.numberOfSample) {
        case 1:
            return self.passphraseManager.passphraseSymbolString;
        case 2:
            return self.passphraseManager.passphraseReverseSymbolString;
        case 3:
            self.randomDigits = self.passphraseManager.passphraseRandomSymbolArray;
            return [self.passphraseManager  passphraseRandomStringWithArray:self.randomDigits];
    }
    return nil;
}

-(NSString *)wordsSequence{
    switch (self.numberOfSample) {
        case 1:
            return self.passphraseManager.passphraseLocalizedSymbolString;
        case 2:
            return self.passphraseManager.passphraseLocalizedReverseSymbolString;
        case 3:
            return [self.passphraseManager passphraseRandomStringWithArray:[OPCPassphraseManager.sharedInstance passphraseRandomizeArray:self.randomDigits]];
    }
    return nil;
}

-(NSString *)convertToDigits:(NSString *)words{
    return [self.passphraseManager passphraseSymbolByLocalizedString:words];
}


@end

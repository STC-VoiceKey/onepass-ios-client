//
//  OPUIEnrollPhraseManager.h
//  OnePassUI
//
//  Created by Soloshcheva Aleksandra on 10.11.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IOPUIPassphraseManagerProtocol

-(id)initWithNumberOfSample:(NSUInteger)sample;

/**
 Forms the digit sequence based on the order number of voice sample
 
 @return The word sequence
 */
-(NSString *)digitSequence;

/**
 Forms the word sequence based on the digit sequence
 
 @return The word sequence
 */
-(NSString *)wordsSequence;

-(NSUInteger)numberOfSample;

-(NSString *)convertToDigits:(NSString *)words;

@end

@interface OPUIPassphraseManager : NSObject<IOPUIPassphraseManagerProtocol>


@end

//
//  PassphraseManager.h
//  OnePassCore
//
//  Created by Soloshcheva Aleksandra on 22.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Is the manager for creating and controlling the passphrase in different ways
 */
@interface OPCPassphraseManager : NSObject

///---------------------------
/// @name Initialization
///---------------------------

/**
 The shared default instance of `OPCPassphraseManager` initialized with default values.
 */
+(OPCPassphraseManager *)sharedInstance;

///---------------------------
/// @name Util Methods
///---------------------------

/*!
 Forms the localized string from the array of symbols from .plist
 @code
  example : 0 1 2 3 4 5 6 7 8 9
 @endcode
 @return The string of the symbols separated by whitespace
 */
-(NSString *)passphraseSymbolString;

/**
 Forms the localized string from the array of symbols from .plist
 @code
  example : zero one two three four five six seven eight nine
 @endcode
 @return The string of the localized symbols separated by whitespace
 */
-(NSString *)passphraseLocalizedSymbolString;

/**
 Forms the reversed string from the array of symbols from .plist
 @code
  example : 9 8 7 6 5 4 3 2 1 0
 @endcode
 @return The reversed string of the symbols separated by whitespace
 */
-(NSString *)passphraseReverseSymbolString;

/**
 Forms the localized reversed string from the array of symbols from .plist
 @code
  example : nine eight seven six five four three two one zero
 @endcode
 @return The reversed localized string of the symbols separated by whitespace
 */
-(NSString *)passphraseLocalizedReverseSymbolString;

/**
 Randomizes symbols in the array from .plist
 @return The randomized array
 */
-(NSArray<NSString *> *)passphraseRandomSymbolArray;

/**
 Localizes symbols in the array
 @param randomArray The localizable array
 @return The localized array
 */
-(NSArray<NSString *> *)passphraseRandomizeArray:(NSArray<NSString *> *)randomArray;

/**
 Concatenates symbols from the array into the string
 @param randomArray The array to be concatenated
 @return The concatenated string of symbols separated by whitespace
 */
-(NSString *)passphraseRandomStringWithArray:(NSArray<NSString *> *)randomArray;

/**
 Converts the localized string to an array of symbols
 @code
 example
    before : one two four eight six
    after  : 1 2 4 8 6
 @endcode
 @param string The string with localized symbols
 @return The array of unlocalized symbols
 */
-(NSString *)passphraseSymbolByLocalizedString:(NSString *)string;

@end

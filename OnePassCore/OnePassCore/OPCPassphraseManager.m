 //
//  PassphraseManager.m
//  OnePassCore
//
//  Created by Soloshcheva Aleksandra on 22.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "OPCPassphraseManager.h"

/**
 The constant name for the passphrase .plist file name
 */
static NSString *kPassphrasePlistName  = @"PassphrasePlistName";

/**
 The constant name for the passphrase localization file name
 */
static NSString *kPassphraseStringName = @"PassphraseStringName";

@interface OPCPassphraseManager (PrivateMethods)

/**
 The path for the localization file with values for the passphrase
 */
@property ( nonatomic, readonly) NSString *pathLocalizationFileName;

/**
 The bundle for localization resouces
 */
@property ( nonatomic, readonly) NSString *localizationBundle;

///-----------------------------------
/// @name Private Methods
///-----------------------------------

/**
 Reads the array of symbols from .plist
 @return The array of symbols 
 */
-(NSArray<NSString *> *)passphraseSymbolArray;

/**
 Localizes the array of symbols from .plist
 @return The array of localized symbols
 */
-(NSArray<NSString *> *)passphraseLocalizedArray;

/**
 Reads the array of symbols from .plist and returns the reversed array
 @return The reversed array of symbols
 */
-(NSArray<NSString *> *)passphraseReverseSymbolArray;

/**
 Localizes the reversed array of symbols from .plist
 @return The reversed array of localized symbols
 */
-(NSArray<NSString *> *)passphraseReverseArray;

@end

@implementation OPCPassphraseManager

+(OPCPassphraseManager *)sharedInstance{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[OPCPassphraseManager alloc] init];
    });
    return sharedInstance;
}

-(NSString *)passphraseSymbolString{
    return [OPCPassphraseManager.sharedInstance.passphraseSymbolArray componentsJoinedByString:@" "];
}

-(NSString *)passphraseLocalizedSymbolString{
    return [OPCPassphraseManager.sharedInstance.passphraseLocalizedArray componentsJoinedByString:@" "];
}

-(NSString *)passphraseReverseSymbolString{
    return [OPCPassphraseManager.sharedInstance.passphraseReverseSymbolArray componentsJoinedByString:@" "];
}

-(NSString *)passphraseLocalizedReverseSymbolString{
    return [OPCPassphraseManager.sharedInstance.passphraseReverseArray componentsJoinedByString:@" "];
}

-(NSArray<NSString *> *)passphraseRandomSymbolArray{
    NSMutableArray<NSString *> *sourceArray = OPCPassphraseManager.sharedInstance.passphraseSymbolArray.mutableCopy;
    NSMutableArray<NSString *> *destArray   = [NSMutableArray arrayWithCapacity:sourceArray.count];

    NSUInteger lenght = sourceArray.count;
    for (int i = 0; i < lenght; i++) {
        u_int32_t randomIndex = arc4random_uniform((u_int32_t)sourceArray.count);
        NSString *digit = [sourceArray objectAtIndex:randomIndex];
        [sourceArray removeObjectAtIndex:randomIndex];
        [destArray setObject:digit atIndexedSubscript:i];
    }
    
    return destArray;
}

-(NSArray<NSString *> *)passphraseRandomizeArray:(NSArray<NSString *> *)randomArray{

    NSMutableArray *localizedArray = [[NSMutableArray alloc] initWithCapacity:randomArray.count];
    
    for (int i = 0; i < randomArray.count; i++){
        NSString *digit = randomArray[i];
        NSString *localKey = NSLocalizedStringFromTable(digit, self.localizationBundle, nil);
        [localizedArray setObject:localKey atIndexedSubscript:i];
    }
    return localizedArray;
}

-(NSString *)passphraseRandomStringWithArray:(NSArray<NSString *> *)randomArray{
    return [randomArray componentsJoinedByString:@" "];
}

-(NSString *)passphraseSymbolByLocalizedString:(NSString *)string{
    
    NSMutableArray<NSString *> *localizedArray = [NSMutableArray arrayWithArray:[string componentsSeparatedByString:@" "]];
    
    NSDictionary *sourceDictionary = [NSDictionary dictionaryWithContentsOfFile:self.pathLocalizationFileName];
    NSMutableDictionary *destionationDictionary = [[NSMutableDictionary alloc] initWithCapacity:sourceDictionary.count];
    
    for (NSString *key in sourceDictionary.allKeys) {
        [destionationDictionary setObject:key forKey:[sourceDictionary objectForKey:key]];
    }
    
    NSMutableArray<NSString *> *resultArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < localizedArray.count; i++){
        
        NSString *value = [localizedArray objectAtIndex:i];
        if ([destionationDictionary objectForKey:value] ){
            [resultArray setObject:[destionationDictionary objectForKey:value] atIndexedSubscript:i];
        }
    }

    return [resultArray componentsJoinedByString:@" "];
}

@end

@implementation OPCPassphraseManager (PrivateMethods)

-(NSString *)pathLocalizationFileName{
    return [NSBundle.mainBundle pathForResource: [NSBundle.mainBundle objectForInfoDictionaryKey:kPassphraseStringName] ofType:@"strings"];
}

-(NSString *)localizationBundle{
    return [NSBundle.mainBundle objectForInfoDictionaryKey:kPassphraseStringName];
}

-(NSArray<NSString *> *)passphraseSymbolArray{
    static dispatch_once_t once;
    static NSArray *passphrases;
    dispatch_once(&once, ^{
        NSString *ppPlistPath  = [NSBundle.mainBundle pathForResource: [NSBundle.mainBundle objectForInfoDictionaryKey:kPassphrasePlistName] ofType:@"plist"];
        passphrases = [NSDictionary dictionaryWithContentsOfFile:ppPlistPath][@"passphrase"];
    });
    return passphrases;
}

-(NSArray<NSString *> *)passphraseLocalizedArray
{
    NSMutableArray *localizedArray = [[NSMutableArray alloc] initWithCapacity:self.passphraseSymbolArray.count];
    
    for (int i = 0; i<self.passphraseSymbolArray.count; i++){
        
        NSString *digit = self.passphraseSymbolArray[i];
        NSString *localKey = NSLocalizedStringFromTable(digit, self.localizationBundle, nil);
        [localizedArray setObject:localKey atIndexedSubscript:i];
    }
    
    return localizedArray;
}

-(NSArray<NSString *> *)passphraseReverseSymbolArray{
    return  OPCPassphraseManager.sharedInstance.passphraseSymbolArray.reverseObjectEnumerator.allObjects;
}

-(NSArray<NSString *> *)passphraseReverseArray{
    NSMutableArray *localizedArray = [[NSMutableArray alloc]
                                      initWithCapacity:OPCPassphraseManager.sharedInstance.passphraseReverseSymbolArray.count];
    
    for (int i = 0; i < OPCPassphraseManager.sharedInstance.passphraseReverseSymbolArray.count; i++){
        
        NSString *digit = OPCPassphraseManager.sharedInstance.passphraseReverseSymbolArray[i];
        NSString *localKey = NSLocalizedStringFromTable(digit, self.localizationBundle, nil);
        [localizedArray setObject:localKey atIndexedSubscript:i];
    }
    return localizedArray;
}

@end

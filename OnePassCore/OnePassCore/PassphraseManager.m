//
//  PassphraseManager.m
//  OnePassCore
//
//  Created by Soloshcheva Aleksandra on 22.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import "PassphraseManager.h"

static NSString *kPassphrasePlistName  = @"PassphrasePlistName";
static NSString *kPassphraseStringName = @"PassphraseStringName";



@implementation PassphraseManager
+(PassphraseManager *)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[PassphraseManager alloc] init];
    });
    return sharedInstance;
}

-(NSString *)localizationFileName{
    return [[NSBundle mainBundle] pathForResource: [[NSBundle mainBundle] objectForInfoDictionaryKey:kPassphraseStringName] ofType:@"strings"];
}

-(NSString *)localizationBundle{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:kPassphraseStringName];
}


-(NSArray<NSString *> *)passphraseDigitArray{
    static dispatch_once_t once;
    static NSArray *passphrases;
    dispatch_once(&once, ^{

        NSString *ppPlistPath  = [[NSBundle mainBundle] pathForResource: [[NSBundle mainBundle] objectForInfoDictionaryKey:kPassphrasePlistName] ofType:@"plist"];
        passphrases = [NSDictionary dictionaryWithContentsOfFile:ppPlistPath][@"passphrase"];
    });
    return passphrases;

}

-(NSString *)passphraseDigitString{
    return [[[PassphraseManager sharedInstance] passphraseDigitArray] componentsJoinedByString:@" "];
}

-(NSArray<NSString *> *)passphraseLocalizedArray
{
    NSMutableArray *localizedArray = [[NSMutableArray alloc] initWithCapacity:[self passphraseDigitArray].count];
    
    for (int i = 0; i<[self passphraseDigitArray].count; i++)
    {
        NSString *digit = [self passphraseDigitArray][i];
        NSString *localKey = NSLocalizedStringFromTable(digit,[self localizationBundle], nil);
        [localizedArray setObject:localKey atIndexedSubscript:i];
    }
    
    return localizedArray;
}

-(NSString *)passphraseLocalizedString{
    return [[self passphraseLocalizedArray] componentsJoinedByString:@" "];
}

-(NSArray<NSString *> *)passphraseReverseDigitArray{
    return  [[[[PassphraseManager sharedInstance] passphraseDigitArray] reverseObjectEnumerator] allObjects];
}
-(NSString *)passphraseReverseDigitString{
    return [[[PassphraseManager sharedInstance] passphraseReverseDigitArray] componentsJoinedByString:@" "];
}

-(NSArray<NSString *> *)passphraseReverseArray{
    NSMutableArray *localizedArray = [[NSMutableArray alloc] initWithCapacity:[[PassphraseManager sharedInstance] passphraseReverseDigitArray].count];
    
    for (int i = 0; i<[[PassphraseManager sharedInstance] passphraseReverseDigitArray].count; i++)
    {
        NSString *digit = [[PassphraseManager sharedInstance] passphraseReverseDigitArray][i];
        NSString *localKey = NSLocalizedStringFromTable(digit, [self localizationBundle], nil);
        [localizedArray setObject:localKey atIndexedSubscript:i];
    }
    return localizedArray;
}

-(NSString *)passphraseReverseString{
    return [[[PassphraseManager sharedInstance] passphraseReverseArray] componentsJoinedByString:@" "];
}

-(NSArray<NSString *> *)passphraseRandomDigitArray{
    NSMutableArray<NSString *> *sourceArray = [[[PassphraseManager sharedInstance] passphraseDigitArray] mutableCopy];
    NSMutableArray<NSString *> *destArray   = [NSMutableArray arrayWithCapacity:sourceArray.count];

    NSUInteger lenght = sourceArray.count;
    for (int i = 0; i < lenght; i++)
    {
        u_int32_t randomIndex = arc4random_uniform((u_int32_t)sourceArray.count);
        NSString *digit = [sourceArray objectAtIndex:randomIndex];
        [sourceArray removeObjectAtIndex:randomIndex];
        [destArray setObject:digit atIndexedSubscript:i];
    }
    
    return destArray;
}


-(NSArray<NSString *> *)passphraseRandomArray:(NSArray<NSString *> *)randomArray{
    NSMutableArray *localizedArray = [[NSMutableArray alloc] initWithCapacity:randomArray.count];
    
    for (int i = 0; i < randomArray.count; i++)
    {
        NSString *digit = randomArray[i];
        NSString *localKey = NSLocalizedStringFromTable(digit, [self localizationBundle], nil);
        [localizedArray setObject:localKey atIndexedSubscript:i];
    }
    return localizedArray;
}


-(NSString *)passphraseRandomStringWithArray:(NSArray<NSString *> *)randomArray{
    return [randomArray componentsJoinedByString:@" "];
}

-(NSString *)passphraseDigitByLocalizedString:(NSString *)string{
    
    NSMutableArray<NSString *> *localizedArray = [NSMutableArray arrayWithArray:[string componentsSeparatedByString:@" "]];
    
    NSDictionary *sourceDictionary = [NSDictionary dictionaryWithContentsOfFile:[self localizationFileName]];
    NSMutableDictionary *destionationDictionary = [[NSMutableDictionary alloc] initWithCapacity:sourceDictionary.count];
    for (NSString *key in [sourceDictionary allKeys]) {
        [destionationDictionary setObject:key forKey:[sourceDictionary objectForKey:key]];
    }
    
    for (int i = 0; i < localizedArray.count; i++)
    {
        NSString *value = [localizedArray objectAtIndex:i];
        if ([destionationDictionary objectForKey:value] )
            [localizedArray setObject:[destionationDictionary objectForKey:value] atIndexedSubscript:i];
    }

    return [localizedArray componentsJoinedByString:@" "];
}

@end

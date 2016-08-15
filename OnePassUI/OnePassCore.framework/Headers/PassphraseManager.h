//
//  PassphraseManager.h
//  OnePassCore
//
//  Created by Soloshcheva Aleksandra on 22.06.16.
//  Copyright © 2016 Speech Technology Center. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PassphraseManager : NSObject

+(PassphraseManager *)sharedInstance;

-(NSString *)localizationFileName;

-(NSArray<NSString *> *)passphraseDigitArray;
-(NSString *)passphraseDigitString;

-(NSArray<NSString *> *)passphraseLocalizedArray;
-(NSString *)passphraseLocalizedString;

-(NSArray<NSString *> *)passphraseReverseDigitArray;
-(NSString *)passphraseReverseDigitString;
-(NSArray<NSString *> *)passphraseReverseArray;
-(NSString *)passphraseReverseString;

-(NSArray<NSString *> *)passphraseRandomDigitArray;
-(NSArray<NSString *> *)passphraseRandomArray:(NSArray<NSString *> *)randomArray;
-(NSString *)passphraseRandomStringWithArray:(NSArray<NSString *> *)randomArray;

-(NSString *)passphraseDigitByLocalizedString:(NSString *)string;

@end

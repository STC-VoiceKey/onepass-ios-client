//
//  XCOPCPassphraseManagerTests.swift
//  OnePassCoreTests
//
//  Created by Soloshcheva Aleksandra on 11.10.2017.
//  Copyright © 2017 Speech Technology Center. All rights reserved.
//

import XCTest
import OnePassCore

class PassphraseManagerTests: XCTestCase {
    
    func testSingletonReturnsSameInstance() {
        let firstPassphraseManager  = OPCPassphraseManager.sharedInstance()
        let secondPassphraseManager = OPCPassphraseManager.sharedInstance()
        XCTAssertEqual(firstPassphraseManager, secondPassphraseManager, "OPCPassphraseManager sharedInstance must be returned same instances");
    }
    
    func testPassphraseSymbolString() {
        let passphraseManager = OPCPassphraseManager.sharedInstance()
        let result = passphraseManager?.passphraseSymbolString()
        
        XCTAssertEqual(result, "0 1 2 3 4 5 6 7 8 9", "Test returns '0 1 2 3 4 5 6 7 8 9' failed")
    }
    
    func testPassphraseLocalizedSymbolString() {
        let passphraseManager = OPCPassphraseManager.sharedInstance()
        let result = passphraseManager?.passphraseLocalizedSymbolString()
        XCTAssertEqual(result, "zero one two three four five six seven eight nine","Test returns 'zero one ...' failed")
    }
    
    func testPassphraseReverseSymbolString() {
        let passphraseManager = OPCPassphraseManager.sharedInstance()
        let result = passphraseManager?.passphraseReverseSymbolString()
        
        XCTAssertEqual(result, "9 8 7 6 5 4 3 2 1 0", "Test returns '9 8 7 6 5 4 3 2 1 0' failed")
    }
    
    func testPassphraseReverseLocalizedSymbolString() {
        let passphraseManager = OPCPassphraseManager.sharedInstance()
        let result = passphraseManager?.passphraseLocalizedReverseSymbolString()
        XCTAssertEqual(result, "nine eight seven six five four three two one zero","Test returns 'zero one ...' failed")
    }
    
    func testPassphraseRandomSymbolArray() {
        let passphraseManager = OPCPassphraseManager.sharedInstance()
        
        let array = passphraseManager?.passphraseRandomSymbolArray()
        
        XCTAssertNotNil(array,"Random Symbol Array must be not nil")
        
        let unique = Set(array!)
        
        XCTAssertEqual(array?.count, unique.count, "Random Symbol Array must contain only unique symbols")
    }

    func testPassphraseRandomizeArray() {
        let passphraseManager = OPCPassphraseManager.sharedInstance()
        let result = passphraseManager?.passphraseRandomizeArray(["0","2","4","6","8"])
        XCTAssertEqual(result!, [ "zero", "two", "four", "six", "eight"],"Must be returned localized digit sequence")
    }
    
    func testPassphraseRandomStringWithArray() {
        let passphraseManager = OPCPassphraseManager.sharedInstance()
        let result = passphraseManager?.passphraseRandomString(with: [ "zero", "two", "four", "six", "eight"])
        XCTAssertEqual(result!, "zero two four six eight","Must return concatenated string")
    }
    
    func testpassphraseSymbolByLocalizedString() {
        let passphraseManager = OPCPassphraseManager.sharedInstance()
        let result = passphraseManager?.passphraseSymbol(byLocalizedString:"one two four eight six")
        XCTAssertEqual(result!, "1 2 4 8 6","Doesn't work reverting localization")
    }
}

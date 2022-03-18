//
//  String_SwiftTests.swift
//  JXExtensionKit_SwiftTests
//
//  Created by Barnett on 2021/4/16.
//  Copyright © 2021 Barnett. All rights reserved.
//

import XCTest

class String_SwiftTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_Encrypt() throws {
        var testString = "1234567890"
        var encryptKey = "20200429"
        var desIv = "zhangjianxun"
        
        XCTAssertTrue(testString.md2String() == "38e53522a2e67fc5ea57bae1575a3107")
        XCTAssertTrue(testString.md4String() == "85b196c3e39457d91cab9c905f9a11c0")
        XCTAssertTrue(testString.md5String() == "e807f1fcf82d132f9bb018ca6738a19f")
        print("encryptWithMD5_16bit : " + testString.encryptWithMD5_16bit()!)
        
        XCTAssertTrue(testString.sha1String() == "01b307acba4f54f55aafc33bb06bbbf6ca803e9a")
        XCTAssertTrue(testString.sha224String() == "b564e8a5cf20a254eb34e1ae98c3d957c351ce854491ccbeaeb220ea")
        XCTAssertTrue(testString.sha256String() == "c775e7b757ede630cd0aa1113bd102661ab38829ca52a6422ab782862f268646")
        XCTAssertTrue(testString.sha384String() == "ed845f8b4f2a6d5da86a3bec90352d916d6a66e3420d720e16439adf238f129182c8c64fc4ec8c1e6506bc2b4888baf9")
        XCTAssertTrue(testString.sha512String() == "12b03226a6d8be9c6e8cd5e55dc6c7920caaa39df14aab92d5e3ea9340d1c8a4d3d0b8e4314f1f6ef131ba4bf1ceb9186ab87c801af0d5c95b1befb8cedae2b9")
        
        XCTAssertTrue(testString.hmacMD5StringWithKey(encryptKey) == "01de3e2062a1d46209dbef9a685e19c8")
        XCTAssertTrue(testString.hmacSHA1StringWithKey(encryptKey) == "571a9d96fa688df2a51edf57086d0d0b5fd36e3c")
        XCTAssertTrue(testString.hmacSHA224StringWithKey(encryptKey) == "70c549ba7c953b0e48fd30d6cf384a9004fffd79dfdf01cfc0dcc537")
        XCTAssertTrue(testString.hmacSHA256StringWithKey(encryptKey) == "bf14cf26fd5beafd9575a764158ae03cb6a5b6fbb72492bdb2052e8ff1e4a721")
        XCTAssertTrue(testString.hmacSHA384StringWithKey(encryptKey) == "cb68513d18860e62143de511c747ce5651c5aace9112b672544020099337638dd2bad3ad2de85d8d9029d53e6127e2ee")
        XCTAssertTrue(testString.hmacSHA512StringWithKey(encryptKey) == "6f56ee663fea8497d6912d867b3d7c6cab5c4a8bae7908a59217fd1765836019013ab914d64a440c09eaddc187796a6bdcfc4175ffbf722984c085f432e0b813")
        
        XCTAssertTrue(testString.encodeWithBase64With(optinon: .lineLength64Characters)?.decodeWithBase64() == testString)
        
        // DES
        testString = "1234567890"
        encryptKey = "20200429"
        desIv = "zhangjianxun"
        
        let desIvString = testString.enCrypt(algorithm: .DES, keyString: encryptKey, iv: desIv, useBase64: false)
        let desIvBase64String = testString.enCrypt(algorithm: .DES, keyString: encryptKey, iv: desIv, useBase64: true)
        let desString = testString.enCrypt(algorithm: .DES, keyString: encryptKey, iv: nil, useBase64: false)
        let desBase64String = testString.enCrypt(algorithm: .DES, keyString: encryptKey, iv: nil, useBase64: true)
        XCTAssertTrue(desIvString?.uppercased() == "02B7BD3B2BF95B21A4B8182CF11527CC")
        XCTAssertTrue(desIvBase64String == "Are9Oyv5WyGkuBgs8RUnzA==")
        XCTAssertTrue(desString?.uppercased() == "12E3C1C2A5B7B7D0431DE7E40F0128E3")
        XCTAssertTrue(desBase64String == "EuPBwqW3t9BDHefkDwEo4w==")
        XCTAssertTrue(desIvString?.deCrypt(algorithm: .DES, keyString: encryptKey, iv: desIv, useBase64: false) == testString)
        XCTAssertTrue(desIvBase64String?.deCrypt(algorithm: .DES, keyString: encryptKey, iv: desIv, useBase64: true) == testString)
        XCTAssertTrue(desString?.deCrypt(algorithm: .DES, keyString: encryptKey, iv: nil, useBase64: false) == testString)
        XCTAssertTrue(desBase64String?.deCrypt(algorithm: .DES, keyString: encryptKey, iv: nil, useBase64: true) == testString)
        
        // aes128
        testString = "1234567890"
        encryptKey = "20210415165416gg"
        desIv = "zhangjianxunhaha"
        
        let aesiv128String = testString.enCrypt(algorithm: .AES128, keyString: encryptKey, iv: desIv, useBase64: false)
        let aesiv128Base64String = testString.enCrypt(algorithm: .AES128, keyString: encryptKey, iv: desIv, useBase64: true)
        let aes128String = testString.enCrypt(algorithm: .AES128, keyString: encryptKey, iv: nil, useBase64: false)
        let aes128Base64String = testString.enCrypt(algorithm: .AES128, keyString: encryptKey, iv: nil, useBase64: true)
        XCTAssertTrue(aesiv128String?.uppercased() == "9720E6F3D3ED5AD076078D67705DF296")
        XCTAssertTrue(aesiv128Base64String == "lyDm89PtWtB2B41ncF3ylg==")
        XCTAssertTrue(aes128String?.uppercased() == "1B709E872A07897F1AA2BB37D76DED02")
        XCTAssertTrue(aes128Base64String == "G3CehyoHiX8aors3123tAg==")
        XCTAssertTrue(aesiv128String?.deCrypt(algorithm: .AES128, keyString: encryptKey, iv: desIv, useBase64: false) == testString)
        XCTAssertTrue(aesiv128Base64String?.deCrypt(algorithm: .AES128, keyString: encryptKey, iv: desIv, useBase64: true) == testString)
        XCTAssertTrue(aes128String?.deCrypt(algorithm: .AES128, keyString: encryptKey, iv: nil, useBase64: false) == testString)
        XCTAssertTrue(aes128Base64String?.deCrypt(algorithm: .AES128, keyString: encryptKey, iv: nil, useBase64: true) == testString)
        
        // aes192
        testString = "1234567890"
        encryptKey = "20210415165416zhangjianx"
        desIv = "zhangjianxunhaha"
        
        let aesiv192String = testString.enCrypt(algorithm: .AES192, keyString: encryptKey, iv: desIv, useBase64: false)
        let aesiv192Base64String = testString.enCrypt(algorithm: .AES192, keyString: encryptKey, iv: desIv, useBase64: true)
        let aes192String = testString.enCrypt(algorithm: .AES192, keyString: encryptKey, iv: nil, useBase64: false)
        let aes192Base64String = testString.enCrypt(algorithm: .AES192, keyString: encryptKey, iv: nil, useBase64: true)
        XCTAssertTrue(aesiv192String?.uppercased() == "1516F3148FF6385C2F5A515A4FA8A7D8")
        XCTAssertTrue(aesiv192Base64String == "FRbzFI/2OFwvWlFaT6in2A==")
        XCTAssertTrue(aes192String?.uppercased() == "6988D5E8A033042223FB02FB199DB1A4")
        XCTAssertTrue(aes192Base64String == "aYjV6KAzBCIj+wL7GZ2xpA==")
        XCTAssertTrue(aesiv192String?.deCrypt(algorithm: .AES192, keyString: encryptKey, iv: desIv, useBase64: false) == testString)
        XCTAssertTrue(aesiv192Base64String?.deCrypt(algorithm: .AES192, keyString: encryptKey, iv: desIv, useBase64: true) == testString)
        XCTAssertTrue(aes192String?.deCrypt(algorithm: .AES192, keyString: encryptKey, iv: nil, useBase64: false) == testString)
        XCTAssertTrue(aes192Base64String?.deCrypt(algorithm: .AES192, keyString: encryptKey, iv: nil, useBase64: true) == testString)
        
        // aes256
        testString = "1234567890"
        encryptKey = "20210415165416zhangjianxunqazwsx"
        desIv = "zhangjianxunhaha"
        
        let aesiv256String = testString.enCrypt(algorithm: .AES256, keyString: encryptKey, iv: desIv, useBase64: false)
        let aesiv256Base64String = testString.enCrypt(algorithm: .AES256, keyString: encryptKey, iv: desIv, useBase64: true)
        let aes256String = testString.enCrypt(algorithm: .AES256, keyString: encryptKey, iv: nil, useBase64: false)
        let aes256Base64String = testString.enCrypt(algorithm: .AES256, keyString: encryptKey, iv: nil, useBase64: true)
        XCTAssertTrue(aesiv256String?.uppercased() == "9AAE7A5F99B79F78E8BD1C359B34FE75")
        XCTAssertTrue(aesiv256Base64String == "mq56X5m3n3jovRw1mzT+dQ==")
        XCTAssertTrue(aes256String?.uppercased() == "E0E4DECBCD6F7E59850A90346A23F3A3")
        XCTAssertTrue(aes256Base64String == "4OTey81vflmFCpA0aiPzow==")
        XCTAssertTrue(aesiv256String?.deCrypt(algorithm: .AES256, keyString: encryptKey, iv: desIv, useBase64: false) == testString)
        XCTAssertTrue(aesiv256Base64String?.deCrypt(algorithm: .AES256, keyString: encryptKey, iv: desIv, useBase64: true) == testString)
        XCTAssertTrue(aes256String?.deCrypt(algorithm: .AES256, keyString: encryptKey, iv: nil, useBase64: false) == testString)
        XCTAssertTrue(aes256Base64String?.deCrypt(algorithm: .AES256, keyString: encryptKey, iv: nil, useBase64: true) == testString)
        
    }
    
    func test_Format() throws {
        let moneyString = "6743987234571"
        XCTAssertTrue(moneyString.changeNumberToMoneyFormat() == "6,743,987,234,571.00")
        let phoneNumberString = "17330518800"
        XCTAssertTrue(phoneNumberString.phoneNumberHideMiddle() == "173****8800")
        let testString = "\n移除首位换行符\n"
        XCTAssertTrue(testString.removeFirstAndLastLineBreak() == "移除首位换行符")
        let idCardString = "13020619930529031X"
        XCTAssertTrue(idCardString.idCardFormat() == "130206 1993 0529 031X")
        let bankString = "6217000780021720199"
        XCTAssertTrue(bankString.bankCardFormat() == "6217 0007 8002 1720 199")
        let testString1 = "测试代码1"
        XCTAssert(testString1.hexString() == "e6b58be8af95e4bba3e7a08131")
        let testString2 = "e6b58be8af95e4bba3e7a08131"
        XCTAssertTrue(testString2.hexStringToNormal() == testString2)
    }
    
    func test_General() throws {
        var string = "情感破裂时刻，你一定会倍感迷茫，不清楚如何继续前进。终于意识到无法放弃，选择挽回对方，却察觉到挽回没想象中那么简单。你选择前进，..."
        XCTAssertTrue(string.subStringToIndex(10) == "情感破裂时刻，你一定")
        XCTAssertTrue(string.subStringFromIndex(30) == "到无法放弃，选择挽回对方，却察觉到挽回没想象中那么简单。你选择前进，...")
        XCTAssertTrue(string.subStringWithRange(NSRange.init(location: 10, length: 10)) == "会倍感迷茫，不清楚如")
        string = "测试代码"
        XCTAssertTrue(string.pinyinString() == "ce shi dai ma")
        XCTAssertTrue(string.firstCharacterString() == "C")
        XCTAssertTrue(string.getStringLenthOfBytes() == 8)
        XCTAssertTrue(string.subBytesOfstringToIndex(5) == "测试")
    }
    
    func test_Verification() throws {
        XCTAssertTrue("123$@%!*?&345".accountNumberIsValidateWithSpecialCharacters("@$!%*?&", min: 6, max: 20))
        XCTAssertFalse("123$".accountNumberIsValidateWithSpecialCharacters("@$!%*?&", min: 6, max: 20))
        XCTAssertFalse("123@$!%*?&234324234234234".accountNumberIsValidateWithSpecialCharacters("@$!%*?&", min: 6, max: 20))
        XCTAssertFalse("123$@%)(".accountNumberIsValidateWithSpecialCharacters("@$!%*?&", min: 6, max: 20))
        
        XCTAssertTrue("13467897766".mobileIsValidate())
        XCTAssertFalse("134678977".mobileIsValidate())
        
        XCTAssertTrue("13467897766".CMMobileIsValidate())
        XCTAssertFalse("13067897766".CMMobileIsValidate())
        
        XCTAssertTrue("13067897766".CUMobileIsValidate())
        XCTAssertFalse("13467897766".CUMobileIsValidate())
        
        XCTAssertTrue("13367897766".CTMobileIsValidate())
        XCTAssertFalse("13467897766".CTMobileIsValidate())
        
        XCTAssertTrue("493650065@qq.com".emailIsValidate())
        XCTAssertFalse("493650065@.com".emailIsValidate())
        
        XCTAssertTrue("123$@%!*?&3aB".accountPasswordIsValidateWithSpecialCharacters("@$!%*?&", leastOneNumber: true, leastOneUppercaseLetter: true, leastOneLowercaseLetter: true, leastOneSpecialCharacters: true, min: 6, max: 20))
        XCTAssertTrue("123$@%!*?&3aB".accountPasswordIsValidateWithSpecialCharacters("@$!%*?&", leastOneNumber: false, leastOneUppercaseLetter: false, leastOneLowercaseLetter: false, leastOneSpecialCharacters: false, min: 6, max: 20))
        
        XCTAssertTrue("456789".verificationCodeIsValidateWithMin(6, max: 6))
        XCTAssertFalse("456789".verificationCodeIsValidateWithMin(5, max: 5))
        
        XCTAssertTrue("13020619930529031X".identityCardIsValidate())
        XCTAssertFalse("1302061993529031X".identityCardIsValidate())
        XCTAssertFalse("13020619930529031C".identityCardIsValidate())
        XCTAssertFalse("123456789098765432".identityCardIsValidate())
        
        XCTAssertTrue("123456".QQCodeIsValidate())
        
        XCTAssertTrue("www.baidu.com".URLStringIsValidate())
        XCTAssertTrue("www.baidu.com.qqcom".URLStringIsValidate())
        
        XCTAssertFalse("www.baidu.com.qqcom".hanNumCharStringIsValidate())
        XCTAssertTrue("数字zimu123".hanNumCharStringIsValidate())
        
        XCTAssertTrue("wwwbaiducomqqcom".stringIsAllEnglishAlphabet());
        XCTAssertFalse("数字zimu123".stringIsAllEnglishAlphabet());
        
        XCTAssertTrue("wwwbaiducomqqcom".stringIsAllEnglishAlphabet());
        XCTAssertFalse("数字zimu123".stringIsAllEnglishAlphabet());
        
        XCTAssertTrue("wwwbaiducomqqcom汉字123_".stringIsChineseCharacterAndLettersAndNumbersAndUnderScore());
        XCTAssertFalse("数字zimu123?".stringIsChineseCharacterAndLettersAndNumbersAndUnderScore());
        
        XCTAssertTrue("wwwbaiducomqqcom😡".stringIsContainsEmoji());
        XCTAssertFalse("数字zimu123?".stringIsContainsEmoji());
        
        XCTAssertTrue("12390865".stringIsInteger());
        XCTAssertTrue("-12390865".stringIsInteger());
        XCTAssertFalse("数字zimu123?".stringIsInteger());
        
        XCTAssertTrue("12390865".stringIsPositiveInteger());
        XCTAssertFalse("-12390865".stringIsPositiveInteger());
        XCTAssertFalse("数字zimu123?".stringIsPositiveInteger());
        
        XCTAssertTrue("0".stringIsNon_PositiveInteger());
        XCTAssertTrue("-12390865".stringIsNon_PositiveInteger());
        XCTAssertFalse("数字zimu123?".stringIsNon_PositiveInteger());
        XCTAssertFalse("12390865".stringIsNon_PositiveInteger());
        
        XCTAssertTrue("-123".stringIsNegativeInteger());
        XCTAssertFalse("数字zimu123?".stringIsNegativeInteger());
        XCTAssertFalse("-12390865.6".stringIsNegativeInteger());
        XCTAssertFalse("0".stringIsNegativeInteger());
        
        XCTAssertTrue("123".stringIsNon_NegativeInteger());
        XCTAssertTrue("0".stringIsNon_NegativeInteger());
        XCTAssertFalse("数字zimu123?".stringIsNon_NegativeInteger());
        XCTAssertFalse("12390865.6".stringIsNon_NegativeInteger());
        XCTAssertFalse("-122".stringIsNon_NegativeInteger());
        
        XCTAssertTrue("123.45".stringIsPositiveFloat());
        XCTAssertFalse("数字zimu123?".stringIsPositiveFloat());
        XCTAssertFalse("-12390865.6".stringIsPositiveFloat());
        XCTAssertFalse("-122".stringIsPositiveFloat());
        XCTAssertFalse("0".stringIsPositiveFloat());
        
        XCTAssertTrue("-123.45".stringIsNegativeFloat());
        XCTAssertFalse("数字zimu123?".stringIsNegativeFloat());
        XCTAssertFalse("12390865.6".stringIsNegativeFloat());
        XCTAssertFalse("122".stringIsNegativeFloat());
        XCTAssertFalse("0".stringIsNegativeFloat());
        
        XCTAssertTrue("-123.45".stringIsFloat());
        XCTAssertTrue("123.45".stringIsFloat());
        XCTAssertFalse("数字zimu123?".stringIsFloat());
        XCTAssertFalse("12390865".stringIsFloat());
        XCTAssertFalse("-122".stringIsFloat());
        XCTAssertFalse("0".stringIsFloat());
    }
}

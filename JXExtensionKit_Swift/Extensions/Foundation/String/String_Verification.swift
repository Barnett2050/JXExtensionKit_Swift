//
//  String_Verification.swift
//  JXExtensionKit_Swift
//
//  Created by Barnett on 2020/10/13.
//  Copyright © 2020 Barnett. All rights reserved.
//

import Foundation

extension String {
    
    /// 有效账号验证,数字，(大小写)字母，特殊字符
    /// - Parameters:
    ///   - specialC: 特殊字符 @$!%*?&
    ///   - min: 最少字符
    ///   - max: 最多字符
    func accountNumberIsValidateWithSpecialCharacters(_ specialC : String?, min : Int,max : Int) -> Bool {
        var userNameRegex : String? = nil
        if specialC == nil || specialC!.isEmpty {
            userNameRegex = String.init(format: "^[A-Za-z0-9]{%ld,%ld}+$",min,max)
        } else {
            userNameRegex = String.init(format: "^[A-Za-z0-9%@]{%ld,%ld}+$", specialC!,min,max)
        }
        return self.isValidateWith(userNameRegex)
    }
    
    /*
     手机号码验证
     移动：134,135,136,137,138,139,147,148,150,151,152,157,158,159,172、178、182、183、184、187、188、198
     联通：130、131、132、145（无线上网卡）,146、155、156,166,171、175、176、185、186、
     电信：133、149、153、173,174、177、180、181、189,199
     */
    func mobileIsValidate() -> Bool {
        let mobileRegex = "^1(3[0-9]|4[6-9]|5[0-35-9]|6[6]|7[0-8]|8[0-9]|9[89])\\d{8}$"
        return self.isValidateWith(mobileRegex)
    }
    
    /// 中国移动手机号码验证 China Mobile
    func CMMobileIsValidate() -> Bool {
        let cmRegex = "^1(3[4-9]|4[78]|5[0-27-9]|7[28]|8[2-478]|9[8])\\d{8}$"
        return self.isValidateWith(cmRegex)
    }
    
    /// 中国联通手机号码验证 China Unicom
    func CUMobileIsValidate() -> Bool {
        let cuRegex = "^1(3[0-2]|4[6]|5[56]|6[6]|7[156]|8[56])\\d{8}$"
        return self.isValidateWith(cuRegex)
    }
    
    /// 中国电信手机号码验证 China Telecom
    func CTMobileIsValidate() -> Bool {
        let ctRegex = "^1(3[3]|4[9]|5[3]|7[347]|8[019]|9[9])\\d{8}$"
        return self.isValidateWith(ctRegex)
    }
    
    /// 有效邮箱验证
    func emailIsValidate() -> Bool {
        /*
         @之前必须有内容且只能是字母（大小写）、数字、下划线(_)、减号（-）、点（.）
         @和最后一个点（.）之间必须有内容且只能是字母（大小写）、数字、点（.）、减号（-），且两个点不能挨着
         最后一个点（.）之后必须有内容且内容只能是字母（大小写）、数字且长度为大于等于2个字节，小于等于6个字节
         */
        let emailRegex = "^[a-zA-Z0-9_.-]+@[a-zA-Z0-9-]+(\\.[a-zA-Z0-9-]+)*\\.[a-zA-Z0-9]{2,6}$"
        return self.isValidateWith(emailRegex)
    }
    
    /// 有效密码验证
    /// - Parameters:
    ///   - specialC: 特殊字符 @$!%*?&
    ///   - leastOneNumber: 至少一个数字
    ///   - leastOneUppercaseLetter: 至少一个大写字母
    ///   - leastOneLowercaseLetter: 至少一个小写字母
    ///   - leastOneSpecialCharacters: 至少一个特殊字符
    ///   - min: 最少字符
    ///   - max: 最多字符
    func accountPasswordIsValidateWithSpecialCharacters(_ specialC : String?,
                                                        leastOneNumber : Bool?,
                                                        leastOneUppercaseLetter : Bool?,
                                                        leastOneLowercaseLetter : Bool?,
                                                        leastOneSpecialCharacters : Bool?,
                                                        min : Int,
                                                        max : Int) -> Bool {
        var passWordRegex : String? = nil
        if specialC != nil && specialC!.count > 0 {
            passWordRegex = String.init(format: "^[A-Za-z0-9%@]{%ld,%ld}$", specialC!,min,max)
        } else {
            passWordRegex = String.init(format: "^[A-Za-z0-9]{%ld,%ld}$", min,max)
        }
        if leastOneNumber != nil && leastOneNumber! {
            passWordRegex!.insert(contentsOf: "(?=.*[0-9])", at: passWordRegex!.index(passWordRegex!.startIndex, offsetBy: 1))
        }
        if leastOneUppercaseLetter != nil && leastOneUppercaseLetter! {
            passWordRegex!.insert(contentsOf: "(?=.*[A-Z])", at: passWordRegex!.index(passWordRegex!.startIndex, offsetBy: 1))
        }
        if leastOneLowercaseLetter != nil && leastOneLowercaseLetter! {
            passWordRegex!.insert(contentsOf: "(?=.*[a-z])", at: passWordRegex!.index(passWordRegex!.startIndex, offsetBy: 1))
        }
        if leastOneSpecialCharacters != nil && leastOneSpecialCharacters! && (specialC != nil && specialC!.count > 0) {
            let scString = String.init(format: "(?=.*[%@])", specialC!)
            passWordRegex!.insert(contentsOf: scString, at: passWordRegex!.index(passWordRegex!.startIndex, offsetBy: 1))
        }
        return self.isValidateWith(passWordRegex!)
    }
    
    /// 有效验证码验证
    /// - Parameters:
    ///   - min: 最少字符
    ///   - max: 最多字符
    func verificationCodeIsValidateWithMin(_ min : NSInteger,max : NSInteger) -> Bool {
        let regex = String.init(format: "^(\\d{%ld,%ld})",min,max)
        return self.isValidateWith(regex)
    }
    
    /// 身份证号码验证
    func identityCardIsValidate() -> Bool {
        if (self.count == 15 || self.count == 18) == false {
            return false
        }
        
        // 地址码校验
        let addressCode = String.init(self.prefix(2))
        let addressCodeRegex = "^((1[1-5]|2[1-3]|3[1-7]|4[1-3]|5[0-4]|6[1-5]|71|8[1-2]))"
        if addressCode.isValidateWith(addressCodeRegex) == false {
            return false
        }
        
        // 出生日期码校验
        var bornCode : String? = nil
        var bornCodeRegex : String? = nil
        let indexN = self.index(self.startIndex, offsetBy: 6)
        
        if self.count == 15 {
            let indexM = self.index(self.startIndex, offsetBy: 11)
            bornCode = String(self[indexN...indexM])
            bornCodeRegex = "^\\d{2}((0[1-9])|(1[0-2]))(([0-2][1-9])|10|20|30|31)$"
        } else {
            let indexM = self.index(self.startIndex, offsetBy: 13)
            bornCode = String(self[indexN...indexM])
            bornCodeRegex = "^(19|20)\\d{2}((0[1-9])|(1[0-2]))(([0-2][1-9])|10|20|30|31)$"
        }
        if bornCode!.isValidateWith(bornCodeRegex) == false {
            return false
        }
        
        // 校验码校验
        if self.count == 15 {
            return self.isValidateWith("^(\\d{15})")
        } else {
            let code = String.init(self.prefix(17))
            if code.isValidateWith("^(\\d{17})") == false {
                return false
            }
            let factor = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2]
            let parity = ["1","0","X","9","8","7","6","5","4","3","2"]
            var sum : Int = 0
            for i in 0 ..< code.count {
                let str = code.subStringWithRange(NSRange.init(location: i, length: 1)) ?? ""
                let num = Int.init(str)
                sum += num! * factor[i]
            }
            let parityCode = parity[sum % 11]
            let lastCode = String.init(self.suffix(1)).uppercased()
            return lastCode == parityCode
        }
    }
    
    /// QQ号码验证
    func QQCodeIsValidate() -> Bool {
        let regex = "[1-9][0-9]{4,}";//第一位1-9之间的数字，第二位0-9之间的数字，数字范围4-14个之间
        return self.isValidateWith(regex)
    }
    
    /// 微信号码验证
    func WechatIsValidate() -> Bool {
        let regex = "^[a-zA-Z][a-zA-Z0-9_-]{5,19}$"
        return self.isValidateWith(regex)
    }
    
    /// (个性签名，组织姓名，组织名称）验证
    func inputLegalIsValidate() -> Bool {
        let stringRegex01 = "[\\u4E00-\\u9FA5a-zA-Z0-9\\@\\#\\$\\^\\&\\*\\(\\)\\-\\+\\.\\ \\_]*"
        let stringRegex02 = "[\\u4E00-\\u9FA5]{2,5}(?:·[\\u4E00-\\u9FA5]{2,5})*"
        return (self.isValidateWith(stringRegex01) || self.isValidateWith(stringRegex02)) && !self.stringIsContainsEmoji()
    }
    
    /// 车牌号码验证
    func carNumberIsValidate() -> Bool {
        let regex = "^(([京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领][A-Z](([0-9]{5}[DF])|([DF]([A-HJ-NP-Z0-9])[0-9]{4})))|([京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领][A-Z][A-HJ-NP-Z0-9]{4}[A-HJ-NP-Z0-9挂学警港澳使领]))$"
        return self.isValidateWith(regex)
    }
    
    //    MARK: 其它
    /// 字符串是URL地址验证
    func URLStringIsValidate() -> Bool {
        if self.isEmpty {
            return false
        }
        let regulaStr = "((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)"
        guard let regex = try? NSRegularExpression.init(pattern: regulaStr, options: .caseInsensitive)  else {
            return false
        }
        let arrayOfAllMatches = regex.matches(in: self, options: .reportProgress, range: NSRange.init(location: 0, length: self.count))
        var substringForMatch : String? = nil
        for match : NSTextCheckingResult in arrayOfAllMatches {
            substringForMatch = self.subStringWithRange(match.range)
        }
        return substringForMatch!.count > 0
    }
    
    /// 字符串纯汉字数字字母组成验证
    func hanNumCharStringIsValidate() -> Bool {
        let regex = "^[a-zA-Z0-9\\u4e00-\\u9fa5]*$"
        return self.isValidateWith(regex)
    }
    
    /// 字符串纯字母数字验证
    func numCharStringIsValidate() -> Bool {
        let regex = "^[a-zA-Z0-9]*$"
        return self.isValidateWith(regex)
    }
    
    /// 字符串纯英文字母
    func stringIsAllEnglishAlphabet() -> Bool {
        let regex = "^[A-Za-z]+$"
        return self.isValidateWith(regex)
    }
    
    /// 字符串是否为汉字，字母，数字和下划线组成
    func stringIsChineseCharacterAndLettersAndNumbersAndUnderScore() -> Bool {
        let regex = "^[a-zA-Z0-9\\u4e00-\\u9fa5_]*$"
        return self.isValidateWith(regex)
    }
    
    /// 字符串是否包含表情
    func stringIsContainsEmoji() -> Bool {
        for scalar in unicodeScalars {
            switch scalar.value {
            case
                0x00A0...0x00AF,
                0x2030...0x204F,
                0x2120...0x213F,
                0x2190...0x21AF,
                0x2310...0x329F,
                0x1F000...0x1F9CF:
                return true
            default:
                continue
            }
        }
        return false
    }
    
    /// 字符串判断是否为整数
    func stringIsInteger() -> Bool {
        let regex = "^-?[1-9]\\d*$"
        return self.isValidateWith(regex)
    }
    
    /// 字符串判断是否为正整数
    func stringIsPositiveInteger() -> Bool {
        let regex = "^[1-9]\\d*$"
        return self.isValidateWith(regex)
    }
    
    /// 字符串判断是否为非正整数
    func stringIsNon_PositiveInteger() -> Bool {
        let regex = "^-[1-9]\\d*|0$"
        return self.isValidateWith(regex)
    }
    
    /// 字符串判断是否为负整数
    func stringIsNegativeInteger() -> Bool {
        let regex = "^-[1-9]\\d*$"
        return self.isValidateWith(regex)
    }
    
    /// 字符串判断是否为非负整数
    func stringIsNon_NegativeInteger() -> Bool {
        let regex = "^[1-9]\\d*|0$"
        return self.isValidateWith(regex)
    }
    
    /// 字符串判断是否为正浮点数
    func stringIsPositiveFloat() -> Bool {
        let regex = "^[1-9]\\d*\\.\\d*|0\\.\\d*[1-9]\\d*$"
        return self.isValidateWith(regex)
    }
    
    /// 字符串判断是否为负浮点数
    func stringIsNegativeFloat() -> Bool {
        let regex = "^-[1-9]\\d*\\.\\d*|-0\\.\\d*[1-9]\\d*$"
        return self.isValidateWith(regex)
    }
    
    /// 字符串判断是否为浮点数
    func stringIsFloat() -> Bool {
        let regex = "^-?[1-9]\\d*\\.\\d*|-0\\.\\d*[1-9]\\d*$"
        return self.isValidateWith(regex)
    }
    
    //    MARK: private
    func isValidateWith(_ regexStr : String?) -> Bool {
        if regexStr == nil || regexStr!.isEmpty {
            return false
        }
        let predicate = NSPredicate.init(format:"SELF MATCHES %@", regexStr!)
        return predicate.evaluate(with: self)
    }
}

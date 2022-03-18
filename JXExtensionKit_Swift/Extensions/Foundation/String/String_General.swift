//
//  String_General.swift
//  JXExtensionKit_Swift
//
//  Created by Barnett on 2020/9/9.
//  Copyright © 2020 Barnett. All rights reserved.
//

import Foundation

extension String {
    
    /// 字符串截取到index
    /// - Parameter index: 位置
    func subStringToIndex(_ index : Int) -> String? {
        let minIndex = Double.minimum(Double(index), Double(self.count))
        let newString = self[self.startIndex..<self.index(self.startIndex, offsetBy: Int(minIndex))]
        return String.init(newString)
    }
    
    /// 字符串从index截取到尾部
    /// - Parameter index: 位置
    func subStringFromIndex(_ index : Int) -> String? {
        if index >= self.count {
            return ""
        }
        let newString = self[self.index(self.startIndex, offsetBy: index)..<self.endIndex]
        return String.init(newString)
    }
    
    /// 根据NSRange截取一段字符串
    /// - Parameter range: NSRange
    func subStringWithRange(_ range : NSRange) -> String? {
        if range.location + range.length > self.count {
            return ""
        }
        let newString = self[self.index(self.startIndex, offsetBy: range.location)..<self.index(self.startIndex, offsetBy: range.length+range.location)]
        return String.init(newString)
    }
    
    /// 十六进制字符串返回Data
    func getDataWithHexString() -> Data? {
        var data = Data(capacity: self.count / 2)

        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: self, options: [], range: NSMakeRange(0, self.count)) { match, flags, stop in
            let byteString = (self as NSString).substring(with: match!.range)
            var num = UInt8(byteString, radix: 16)!
            data.append(&num, count: 1)
        }
        guard data.count > 0 else {
            return nil
        }
        return data
    }
    
    /// 从base64编码的字符串返回Data
    func getDataWithBase64EncodedString() -> Data? {
        let data = Data.init(base64Encoded: self, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
        return data
    }
    
    /// 汉字转拼音,每个汉字拼音中间空格隔开
    func pinyinString() -> String? {
        let mutableString = NSMutableString(string: self)
        if CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)  == false ||
            CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false) == false {
            return "";
        }
        return String.init(mutableString)
    }
    
    /// 汉字转为拼音后，返回首字母大写
    func firstCharacterString() -> String? {
        let newString = self.subStringToIndex(1)
        let mutableString = NSMutableString(string: newString!)
        if CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)  == false ||
            CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false) == false {
            return "";
        }
        let result = mutableString.substring(to: 1)
        return String.init(result).uppercased()
        
    }
    
    /// 获取字符串字节长度
    func getStringLenthOfBytes() -> Int {
        var length = 0
        for i in 0..<self.count {
            // 截取字符串中的每一个字符
            let subString = self.subStringWithRange(NSMakeRange(i, 1))
            if self.p_ChineseCharIsValidate(subString) {
                length += 2
            } else {
                length += 1
            }
        }
        return length
    }
    
    /// 根据字节截取字符串
    func subBytesOfstringToIndex(_ index : Int) -> String? {
        var length = 0
        var chineseNum = 0
        var zifuNum = 0
        
        for i in 0..<self.count {
            let subString = self.subStringWithRange(NSMakeRange(i, 1))
            if self.p_ChineseCharIsValidate(subString) {
                if length + 2 > index {
                    return self.subStringToIndex(chineseNum+zifuNum)
                }
                length += 2
                chineseNum += 1
            } else {
                if length + 1 > index {
                    return self.subStringToIndex(chineseNum+zifuNum)
                }
                length += 1
                zifuNum += 1
            }
        }
        return self.subStringToIndex(index)
    }
    
    /// 从html string获取图片url 数组
    func getImageurlFromHtmlString() -> Array<String>? {
        var imageurlArray = Array<String>.init()
        var match : Array<NSTextCheckingResult>? = nil
        
        let parten = "<\\s*img\\s+[^>]*?src\\s*=\\s*[\'\"](.*?)[\'\"]\\s*(alt=[\'\"](.*?)[\'\"])?[^>]*?\\/?\\s*>"
        guard let reg = try? NSRegularExpression.init(pattern: parten, options: .caseInsensitive) else {
            return nil
        }
        match = reg.matches(in: self, options: .reportProgress, range: NSMakeRange(0, self.count-1))
        if match == nil || match == nil || match!.isEmpty {
            return nil
        }
        for result in match! {
            // 获取数组中的标签
            let range = result.range
            let subString = self.subStringWithRange(range)
            var matchArr : Array<NSTextCheckingResult>? = nil
            // 从图片中的标签中提取ImageURL
            guard let subReg = try? NSRegularExpression.init(pattern: "(http|https)://(.*?)\"", options: .caseInsensitive) else {
                return nil
            }
            matchArr = subReg.matches(in: subString!, options: .reportProgress, range: NSMakeRange(0, self.count-1))
            
            if matchArr == nil || matchArr!.isEmpty {
                continue
            }
            let subRes = matchArr![0]
            var subRange = subRes.range
            subRange.length = subRange.length - 1
            let imagekUrl = subString?.subStringWithRange(subRange)
            imageurlArray.append(imagekUrl!)
        }
        return imageurlArray
    }
    
    //    MARK: private
    func p_ChineseCharIsValidate(_ string : String?) -> Bool {
        if string == nil || string!.isEmpty {
            return false
        }
        let nameRegEx = "[\\u0391-\\uFFE5]"
        return string!.isValidateWith(nameRegEx)
    }
}

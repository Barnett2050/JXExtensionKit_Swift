//
//  String_Format.swift
//  JXExtensionKit_Swift
//
//  Created by Barnett on 2020/10/16.
//  Copyright © 2020 Barnett. All rights reserved.
//

import Foundation

extension String {
    
    /// 数字转为金额 例：1000000.00 -> 1,000,000.00
    func changeNumberToMoneyFormat() -> String? {
        let number = Double.init(self)
        let formatter = NumberFormatter.init()
        formatter.positiveFormat = "###,##0.00";
        let newStr = formatter.string(from: NSNumber.init(value: number!))
        return newStr
    }
    
    /// 手机号码中间四位替换****
    func phoneNumberHideMiddle() -> String? {
        if self.count != 11 {
            return self
        }
        var newStr = self
        let range = self.index(self.startIndex, offsetBy: 3)..<self.index(self.startIndex, offsetBy: 7)
        newStr.replaceSubrange(range, with: "****")
        return newStr
    }
    
    /// 移除首尾换行符
    func removeFirstAndLastLineBreak() -> String? {
        var newStr = self
        while newStr.hasPrefix("\n") {
            let range = newStr.startIndex..<newStr.index(newStr.startIndex, offsetBy: 1)
            newStr.removeSubrange(range)
        }
        while newStr.hasSuffix("\n") {
            let range = newStr.index(newStr.endIndex, offsetBy: -1)..<newStr.endIndex
            newStr.removeSubrange(range)
        }
        return newStr
    }
    
    /// 身份证号码格式化 6-4-4-4格式
    func idCardFormat() -> String {
        if self.count != 18 {
            return self
        }
        let regex = "^(\\d{14}|\\d{17})(\\d|[xX])$"
        let identityCardPredicate = NSPredicate.init(format: "SELF MATCHES %@",regex)
        if identityCardPredicate.evaluate(with: self) {
            var array = Array<String>.init()
            var range = self.startIndex..<self.index(self.startIndex, offsetBy: 6)
            array.append(String.init(self[range]))
            range = self.index(self.startIndex, offsetBy: 6)..<self.index(self.startIndex, offsetBy: 10)
            array.append(String.init(self[range]))
            range = self.index(self.startIndex, offsetBy: 10)..<self.index(self.startIndex, offsetBy: 14)
            array.append(String.init(self[range]))
            range = self.index(self.startIndex, offsetBy: 14)..<self.index(self.startIndex, offsetBy: 18)
            array.append(String.init(self[range]))
            
            let newString = String.init(format: "%@ %@ %@ %@", array[0],array[1],array[2],array[3])
            return newString
        }
        return self
    }
    
    /// 银行卡格式化
    func bankCardFormat() -> String {
        var newString : String = ""
        var originalCardNumber = self
        while originalCardNumber.count > 0 {
            var min = Double.minimum(Double(originalCardNumber.count), 4)
            let subString : Substring = originalCardNumber[originalCardNumber.startIndex..<originalCardNumber.index(originalCardNumber.startIndex, offsetBy: String.IndexDistance(min))]
            newString = newString.appending(subString)
            if subString.count == 4 {
                newString = newString.appending(" ")
            }
            min = Double.minimum(Double(originalCardNumber.count), 4)
            originalCardNumber = String(originalCardNumber[originalCardNumber.index(originalCardNumber.startIndex, offsetBy: String.IndexDistance(min))..<originalCardNumber.endIndex])
        }
        return newString
    }
    
    /// 字符串转16进制
    func hexString() -> String? {
        if self.isEmpty { return nil }
        let data = self.data(using: .utf8)
        return data?.hexadecimal()
    }
    
    /// 十六进制字符串转换为正常字符串
    func hexStringToNormal() -> String? {
        let bytes = self.bytes(from: self)
        let data = Data.init(bytes: bytes, count: bytes.count)
        let string = String.init(data: data, encoding: .utf8)
        return string
    }
    
    /// 16进制字符串转字节
    /// - Parameter hexStr: 字符串
    func bytes(from hexStr: String) -> [UInt8] {
        assert(hexStr.count % 2 == 0, "输入字符串格式不对，8位代表一个字符")
        var bytes = [UInt8]()
        var sum = 0
        // 整形的 utf8 编码范围
        let intRange = 48...57
        // 小写 a~f 的 utf8 的编码范围
        let lowercaseRange = 97...102
        // 大写 A~F 的 utf8 的编码范围
        let uppercasedRange = 65...70
        for (index, c) in hexStr.utf8CString.enumerated() {
            var intC = Int(c.byteSwapped)
            if intC == 0 {
                break
            } else if intRange.contains(intC) {
                intC -= 48
            } else if lowercaseRange.contains(intC) {
                intC -= 87
            } else if uppercasedRange.contains(intC) {
                intC -= 55
            } else {
                assertionFailure("输入字符串格式不对，每个字符都需要在0~9，a~f，A~F内")
            }
            sum = sum * 16 + intC
            // 每两个十六进制字母代表8位，即一个字节
            if index % 2 != 0 {
                bytes.append(UInt8(sum))
                sum = 0
            }
        }
        return bytes
    }
}

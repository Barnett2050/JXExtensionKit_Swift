//
//  Data_Encrypt.swift
//  JXExtensionKit_Swift
//
//  Created by Barnett on 2020/9/4.
//  Copyright © 2020 Barnett. All rights reserved.
//

import Foundation
import UIKit
import CommonCrypto
import zlib

enum CryptoAlgorithm {
    case AES128,AES192,AES256,DES,DES3,CAST,RC2,RC4,Blowfish
    var algorithm : CCAlgorithm {
        var result : UInt32 = 0
        switch self {
        case .AES128:
            result = UInt32(kCCAlgorithmAES)
        case .AES192:
            result = UInt32(kCCAlgorithmAES)
        case .AES256:
            result = UInt32(kCCAlgorithmAES)
        case .DES:
            result = UInt32(kCCAlgorithmDES)
        case .DES3:
            result = UInt32(kCCAlgorithm3DES)
        case .CAST:
            result = UInt32(kCCAlgorithmCAST)
        case .RC2:
            result = UInt32(kCCAlgorithmRC2)
        case .RC4:
            result = UInt32(kCCAlgorithmRC4)
        case .Blowfish:
            result = UInt32(kCCAlgorithmBlowfish)
        }
        return CCAlgorithm(result)
    }
    var keyLength : Int {
        var result : Int = 0
        switch self {
        case .AES128:
            result = kCCKeySizeAES128
        case .AES192:
            result = kCCKeySizeAES192
        case .AES256:
            result = kCCKeySizeAES256
        case .DES:
            result = kCCKeySizeDES
        case .DES3:
            result = kCCKeySize3DES
        case .CAST:
            result = kCCKeySizeMaxCAST
        case .RC2:
            result = kCCKeySizeMaxRC2
        case .RC4:
            result = kCCKeySizeMaxRC4
        case .Blowfish:
            result = kCCKeySizeMaxBlowfish
        }
        return Int(result)
    }
    var cryptLength:Int {
        var result:Int = 0
        switch self {
        case .AES128:
            result = kCCKeySizeAES128
        case .AES192:
            result = kCCKeySizeAES192
        case .AES256:
            result = kCCKeySizeAES256
        case .DES:
            result = kCCBlockSizeDES
        case .DES3:
            result = kCCBlockSize3DES
        case .CAST:
            result = kCCBlockSizeCAST
        case .RC2:
            result = kCCBlockSizeRC2
        case .RC4:
            result = kCCBlockSizeRC2
        case .Blowfish:
            result = kCCBlockSizeBlowfish
        }
        return Int(result)
    }
}

extension Data {
    
    /// 返回md2哈希的小写String。
    func md2String() -> String {
        let length = Int(CC_MD2_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: length)
        CC_MD2(NSData.init(data: self).bytes, CC_LONG(self.count), result)
        let hash = NSMutableString()
        for i in 0 ..< length {
            hash.appendFormat("%02x", result[i])
        }
        return String(format: hash as String)
    }
    
    /// 返回md2哈希值的Data。
    func md2Data() -> Data {
        let length = Int(CC_MD2_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: length)
        CC_MD2(NSData.init(data: self).bytes, CC_LONG(self.count), result)
        return Data.init(bytes: result, count: length)
    }
    
    /// 返回md4哈希的小写String。
    func md4String() -> String {
        let length = Int(CC_MD4_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: length)
        CC_MD4(NSData.init(data: self).bytes, CC_LONG(self.count), result)
        let hash = NSMutableString()
        for i in 0 ..< length {
            hash.appendFormat("%02x", result[i])
        }
        return String(format: hash as String)
    }
    
    /// 返回md4哈希值的Data。
    func md4Data() -> Data {
        let length = Int(CC_MD4_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: length)
        CC_MD4(NSData.init(data: self).bytes, CC_LONG(self.count), result)
        return Data.init(bytes: result, count: length)
    }
    
    /// 返回md5哈希的小写String。
    func md5String() -> String {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: length)
        CC_MD5(NSData.init(data: self).bytes, CC_LONG(self.count), result)
        let hash = NSMutableString()
        for i in 0 ..< length {
            hash.appendFormat("%02x", result[i])
        }
        return String(format: hash as String)
    }
    
    /// 返回md5哈希值的Data。
    func md5Data() -> Data {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: length)
        CC_MD5(NSData.init(data: self).bytes, CC_LONG(self.count), result)
        return Data.init(bytes: result, count: length)
    }
    
    /// 返回sha1哈希的小写String。
    func sha1String() -> String {
        let length = Int(CC_SHA1_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: length)
        CC_SHA1(NSData.init(data: self).bytes, CC_LONG(self.count), result)
        let hash = NSMutableString()
        for i in 0 ..< length {
            hash.appendFormat("%02x", result[i])
        }
        return String(format: hash as String)
    }
    
    /// 返回sha1哈希值的Data
    func sha1Data() -> Data {
        let length = Int(CC_SHA1_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: length)
        CC_SHA1(NSData.init(data: self).bytes, CC_LONG(self.count), result)
        return Data.init(bytes: result, count: length)
    }
    
    /// 返回sha224哈希的小写String。
    func sha224String() -> String {
        let length = Int(CC_SHA224_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: length)
        CC_SHA224(NSData.init(data: self).bytes, CC_LONG(self.count), result)
        let hash = NSMutableString()
        for i in 0 ..< length {
            hash.appendFormat("%02x", result[i])
        }
        return String(format: hash as String)
    }
    
    /// 返回sha224哈希值的Data
    func sha224Data() -> Data {
        let length = Int(CC_SHA224_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: length)
        CC_SHA224(NSData.init(data: self).bytes, CC_LONG(self.count), result)
        return Data.init(bytes: result, count: length)
    }
    
    /// 返回sha256哈希的小写String。
    func sha256String() -> String {
        let length = Int(CC_SHA256_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: length)
        CC_SHA256(NSData.init(data: self).bytes, CC_LONG(self.count), result)
        let hash = NSMutableString()
        for i in 0 ..< length {
            hash.appendFormat("%02x", result[i])
        }
        return String(format: hash as String)
    }
    
    /// 返回sha256哈希值的Data
    func sha256Data() -> Data {
        let length = Int(CC_SHA256_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: length)
        CC_SHA256(NSData.init(data: self).bytes, CC_LONG(self.count), result)
        return Data.init(bytes: result, count: length)
    }
    
    /// 返回sha384哈希的小写String。
    func sha384String() -> String {
        let length = Int(CC_SHA384_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: length)
        CC_SHA384(NSData.init(data: self).bytes, CC_LONG(self.count), result)
        let hash = NSMutableString()
        for i in 0 ..< length {
            hash.appendFormat("%02x", result[i])
        }
        return String(format: hash as String)
    }
    
    /// 返回sha384哈希值的Data
    func sha384Data() -> Data {
        let length = Int(CC_SHA384_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: length)
        CC_SHA384(NSData.init(data: self).bytes, CC_LONG(self.count), result)
        return Data.init(bytes: result, count: length)
    }
    
    /// 返回sha512哈希的小写String。
    func sha512String() -> String {
        let length = Int(CC_SHA512_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: length)
        CC_SHA512(NSData.init(data: self).bytes, CC_LONG(self.count), result)
        let hash = NSMutableString()
        for i in 0 ..< length {
            hash.appendFormat("%02x", result[i])
        }
        return String(format: hash as String)
    }
    
    /// 返回sha512哈希值的Data
    func sha512Data() -> Data {
        let length = Int(CC_SHA512_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: length)
        CC_SHA512(NSData.init(data: self).bytes, CC_LONG(self.count), result)
        return Data.init(bytes: result, count: length)
    }
    
    /// 基于散列的消息认证码 HMAC-MD5加密
    func hmacMD5StringWithKey(_ key : String) -> String {
        return self.hmacStringUsingAlg(CCHmacAlgorithm(kCCHmacAlgMD5), key: key)
    }
    /// 基于散列的消息认证码 HMAC-MD5加密
    func hmacMD5DataWithKey(_ key : String) -> Data {
        return self.hmacDataUsingAlg(CCHmacAlgorithm(kCCHmacAlgMD5), key: key)
    }
    
    /// 基于散列的消息认证码 HMAC-SHA1加密
    func hmacSHA1StringWithKey(_ key : String) -> String {
        return self.hmacStringUsingAlg(CCHmacAlgorithm(kCCHmacAlgSHA1), key: key)
    }
    /// 基于散列的消息认证码 HMAC-SHA1加密
    func hmacSHA1DataWithKey(_ key : String) -> Data {
        return self.hmacDataUsingAlg(CCHmacAlgorithm(kCCHmacAlgSHA1), key: key)
    }
    
    /// 基于散列的消息认证码 HMAC-SHA224加密
    func hmacSHA224StringWithKey(_ key : String) -> String {
        return self.hmacStringUsingAlg(CCHmacAlgorithm(kCCHmacAlgSHA224), key: key)
    }
    /// 基于散列的消息认证码 HMAC-SHA224加密
    func hmacSHA224DataWithKey(_ key : String) -> Data {
        return self.hmacDataUsingAlg(CCHmacAlgorithm(kCCHmacAlgSHA224), key: key)
    }
    
    /// 基于散列的消息认证码 HMAC-SHA256加密
    func hmacSHA256StringWithKey(_ key : String) -> String {
        return self.hmacStringUsingAlg(CCHmacAlgorithm(kCCHmacAlgSHA256), key: key)
    }
    /// 基于散列的消息认证码 HMAC-SHA256加密
    func hmacSHA256DataWithKey(_ key : String) -> Data {
        return self.hmacDataUsingAlg(CCHmacAlgorithm(kCCHmacAlgSHA256), key: key)
    }
    
    /// 基于散列的消息认证码 HMAC-SHA384加密
    func hmacSHA384StringWithKey(_ key : String) -> String {
        return self.hmacStringUsingAlg(CCHmacAlgorithm(kCCHmacAlgSHA384), key: key)
    }
    /// 基于散列的消息认证码 HMAC-SHA384加密
    func hmacSHA384DataWithKey(_ key : String) -> Data {
        return self.hmacDataUsingAlg(CCHmacAlgorithm(kCCHmacAlgSHA384), key: key)
    }
    
    /// 基于散列的消息认证码 HMAC-SHA512加密
    func hmacSHA512StringWithKey(_ key : String) -> String {
        return self.hmacStringUsingAlg(CCHmacAlgorithm(kCCHmacAlgSHA512), key: key)
    }
    /// 基于散列的消息认证码 HMAC-SHA512加密
    func hmacSHA512DataWithKey(_ key : String) -> Data {
        return self.hmacDataUsingAlg(CCHmacAlgorithm(kCCHmacAlgSHA512), key: key)
    }
    
    //    MARK:Encode and decode
    /// 返回以UTF8解码的字符串。
    func utf8String() -> String {
        if self.count > 0 {
            return String.init(data: self, encoding: .utf8)!
        }
        return "";
    }
    
    /// 返回十六进制的大写String。
    func hexString() -> String {
        let length = self.count
        var result = String.init()
        let bytes = NSData.init(data: self).bytes
        let i16bufptr = UnsafeBufferPointer(start: bytes.assumingMemoryBound(to: UInt8.self), count: count)
        let i16array = Array(i16bufptr)
        for i in 0 ..< length {
            result.append(String.init(format: "%02X",i16array[i]))
        }
        return result
    }
    
    /// 返回base64编码的String
    func base64EncodedString() -> String {
        let base64Encoded = self.base64EncodedString(options: Base64EncodingOptions.lineLength64Characters)
        return base64Encoded
    }
    
    // 返回NSDictionary或NSArray用于已解码的self。如果发生错误，则返回nil。
    func jsonValueDecoded() -> Any? {
        guard let value = try? JSONSerialization.jsonObject(with: self, options: JSONSerialization.ReadingOptions.fragmentsAllowed) else {
            return nil
        }
        return value
    }
    
    /// 加密
    /// - Parameters:
    ///   - algorithm: 加密方式
    ///   - keyData: 加密key
    ///   - iv: iv 初始化向量
    func enCrypt(algorithm:CryptoAlgorithm,keyData:NSData,iv:NSData?) -> NSData {
        return crypt(algorithm: algorithm, operation: CCOperation(kCCEncrypt), keyData: keyData, iv: iv)!
    }
    
    /// 解密
    /// - Parameters:
    ///   - algorithm: 解密方式
    ///   - keyData: 解密key
    ///   - iv: iv 初始化向量
    func deCrypt(algorithm:CryptoAlgorithm,keyData:NSData,iv:NSData?) -> NSData? {
        return crypt(algorithm: algorithm, operation: CCOperation(kCCDecrypt), keyData: keyData,iv: iv)
    }
    
    //    MARK:私有方法
    /// 加密解密
    func crypt(algorithm:CryptoAlgorithm,operation:CCOperation,keyData:NSData,iv:NSData?) -> NSData? {
        let keyBytes = keyData.bytes
        let keyLength = Int(algorithm.keyLength)
        let datalength = self.count
        let dataBytes = NSData.init(data: self).bytes
        let cryptLength = Int(datalength + algorithm.cryptLength)
        let cryptPointer = UnsafeMutablePointer<UInt8>.allocate(capacity: cryptLength)
        let algoritm: CCAlgorithm = CCAlgorithm(algorithm.algorithm)
        let option: CCOptions = iv?.isEmpty ?? true ? CCOptions(kCCOptionECBMode + kCCOptionPKCS7Padding) : CCOptions(kCCOptionPKCS7Padding)
        let numBytesEncrypted = UnsafeMutablePointer<Int>.allocate(capacity: 1)
        numBytesEncrypted.initialize(to: 0)
        let ivBytes = iv?.isEmpty ?? true ? nil : iv?.bytes
        let cryptStatus = CCCrypt(operation,
                                  algoritm,
                                  option,
                                  keyBytes,
                                  keyLength,
                                  ivBytes,
                                  dataBytes,
                                  datalength,
                                  cryptPointer,
                                  cryptLength,
                                  numBytesEncrypted)
        // 判断是否加密成功
        if CCStatus(cryptStatus) == CCStatus(kCCSuccess) {
            let len = Int(numBytesEncrypted.pointee)
            let data:NSData = NSData(bytesNoCopy: cryptPointer, length: len)
            numBytesEncrypted.deallocate()
            return data
        } else {
            numBytesEncrypted.deallocate()
            cryptPointer.deallocate()
            return nil
        }
    }

    private func hmacStringUsingAlg(_ alg : CCHmacAlgorithm,key : String) -> String {
        var length = 0
        if alg == kCCHmacAlgMD5 {
            length = Int(CC_MD5_DIGEST_LENGTH)
        } else if alg == kCCHmacAlgSHA1 {
            length = Int(CC_SHA1_DIGEST_LENGTH)
        } else if alg == kCCHmacAlgSHA224 {
            length = Int(CC_SHA224_DIGEST_LENGTH)
        } else if alg == kCCHmacAlgSHA256 {
            length = Int(CC_SHA256_DIGEST_LENGTH)
        } else if alg == kCCHmacAlgSHA384 {
            length = Int(CC_SHA384_DIGEST_LENGTH)
        } else if alg == kCCHmacAlgSHA512 {
            length = Int(CC_SHA512_DIGEST_LENGTH)
        }
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: length)
        let cKey = key.cString(using: String.Encoding.utf8)!
        CCHmac(alg, cKey, strlen(cKey), NSData.init(data: self).bytes, self.count, result)
        let hash = NSMutableString()
        for i in 0 ..< length {
            hash.appendFormat("%02x", result[i])
        }
        return String(format: hash as String)
    }
    private func hmacDataUsingAlg(_ alg : CCHmacAlgorithm,key : String) -> Data {
        var length = 0
        if alg == kCCHmacAlgMD5 {
            length = Int(CC_MD5_DIGEST_LENGTH)
        } else if alg == kCCHmacAlgSHA1 {
            length = Int(CC_SHA1_DIGEST_LENGTH)
        } else if alg == kCCHmacAlgSHA224 {
            length = Int(CC_SHA224_DIGEST_LENGTH)
        } else if alg == kCCHmacAlgSHA256 {
            length = Int(CC_SHA256_DIGEST_LENGTH)
        } else if alg == kCCHmacAlgSHA384 {
            length = Int(CC_SHA384_DIGEST_LENGTH)
        } else if alg == kCCHmacAlgSHA512 {
            length = Int(CC_SHA512_DIGEST_LENGTH)
        }
        
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: length)
        let cKey = key.cString(using: String.Encoding.utf8)!
        CCHmac(alg, cKey, strlen(cKey), NSData.init(data: self).bytes, self.count, result)
        return Data.init(bytes: result, count: length)
    }
}

//
//  String_Encrypt.swift
//  JXExtensionKit_Swift
//
//  Created by Barnett on 2020/10/20.
//  Copyright © 2020 Barnett. All rights reserved.
//

import Foundation
import CommonCrypto

extension String {
    //    MARK: - 哈希加密
    /// md2哈希处理
    func md2String() -> String? {
        return self.data(using: .utf8)?.md2String()
    }
    
    /// md4哈希处理
    func md4String() -> String? {
        return self.data(using: .utf8)?.md4String()
    }
    
    /// md5哈希处理
    func md5String() -> String? {
        return self.data(using: .utf8)?.md5String()
    }
    
    /// 16位MD5 哈希处理
    func encryptWithMD5_16bit() -> String? {
        let md5Str = self.md5String()
        var md5_16Str : String? = nil
        if md5Str == nil {
            return nil
        }
        if md5Str!.count > 24 {
            md5_16Str = md5Str?.subStringWithRange(NSMakeRange(8, 16))
        }
        return md5_16Str
    }
    
    /// sha1 哈希处理
    func sha1String() -> String? {
        return self.data(using: .utf8)?.sha1String()
    }
    
    /// sha224 哈希处理
    func sha224String() -> String? {
        return self.data(using: .utf8)?.sha224String()
    }
    
    /// sha256 哈希处理
    func sha256String() -> String? {
        return self.data(using: .utf8)?.sha256String()
    }
    
    /// sha384 哈希处理
    func sha384String() -> String? {
        return self.data(using: .utf8)?.sha384String()
    }
    
    /// sha512 哈希处理
    func sha512String() -> String? {
        return self.data(using: .utf8)?.sha512String()
    }
    
    /// 基于散列的消息认证码 HMAC-MD5加密
    /// - Parameter key: hmac密钥
    func hmacMD5StringWithKey(_ key : String) -> String? {
        return self.data(using: .utf8)?.hmacMD5StringWithKey(key)
    }
    
    /// 基于散列的消息认证码 SHA1加密
    /// - Parameter key: hmac密钥
    func hmacSHA1StringWithKey(_ key : String) -> String? {
        return self.data(using: .utf8)?.hmacSHA1StringWithKey(key)
    }
    
    /// 基于散列的消息认证码 SHA224加密
    /// - Parameter key: hmac密钥
    func hmacSHA224StringWithKey(_ key : String) -> String? {
        return self.data(using: .utf8)?.hmacSHA224StringWithKey(key)
    }
    
    /// 基于散列的消息认证码 SHA256加密
    /// - Parameter key: hmac密钥
    func hmacSHA256StringWithKey(_ key : String) -> String? {
        return self.data(using: .utf8)?.hmacSHA256StringWithKey(key)
    }
    
    /// 基于散列的消息认证码 SHA384加密
    /// - Parameter key: hmac密钥
    func hmacSHA384StringWithKey(_ key : String) -> String? {
        return self.data(using: .utf8)?.hmacSHA384StringWithKey(key)
    }
    
    /// 基于散列的消息认证码 SHA512加密
    /// - Parameter key: hmac密钥
    func hmacSHA512StringWithKey(_ key : String) -> String? {
        return self.data(using: .utf8)?.hmacSHA512StringWithKey(key)
    }
    
    //    MARK: - base64
    /// base64编码
    func encodeWithBase64With(optinon : NSData.Base64EncodingOptions) -> String? {
        let nsdata = self.data(using: .utf8)
        let base64Encoded = nsdata?.base64EncodedString(options: optinon)
        return base64Encoded
    }
    
    /// base64解码
    func decodeWithBase64() -> String? {
        let nsdataFromBase64String = Data.init(base64Encoded: self, options: .ignoreUnknownCharacters)
        let base64Decoded = String.init(data: nsdataFromBase64String!, encoding: .utf8)
        return base64Decoded
    }
    
    /// URL编码
    func URLEncode() -> String? {
        let charactersToEscape = "?!@#$^&%*+,:;='\"`<>()[]{}/\\| "
        let allowedCharacters = CharacterSet.init(charactersIn: charactersToEscape).inverted
        let encodedStr = self.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
        return encodedStr
    }
    
    /// URL解码
    func URLDecode() -> String? {
        let decodedStr = self.removingPercentEncoding
        return decodedStr
    }

    /// 加密
    /// - Parameters:
    ///   - algorithm: 加密方式
    ///   - keyString: 加密key
    ///   - iv: iv 初始化向量
    func enCrypt(algorithm:CryptoAlgorithm,keyString:String,iv:String?,useBase64:Bool) -> String? {
        if self.isEmpty { return nil }
        let data = self.data(using: .utf8)
        let keyData = keyString.data(using: .utf8)!
        var ivData : NSData? = nil
        if iv != nil && iv!.isEmpty == false {
            ivData = NSData.init(data: iv!.data(using: .utf8)!)
        }
        let resultData = data!.enCrypt(algorithm: algorithm, keyData: NSData.init(data: keyData), iv: ivData)
        var outputStr : String? = nil
        if useBase64 {
            let base64Data = resultData.base64EncodedData(options: .lineLength76Characters)
            outputStr = base64Data.utf8String()
        } else {
            outputStr = Data(resultData).hexadecimal()
        }
        return outputStr
    }
    
    /// 解密
    /// - Parameters:
    ///   - algorithm: 解密方式
    ///   - keyData: 解密key
    ///   - iv: iv 初始化向量
    func deCrypt(algorithm:CryptoAlgorithm,keyString:String,iv:String?,useBase64:Bool) -> String? {
        if self.isEmpty { return nil }
        var data : Data? = nil
        if useBase64 {
            data = Data.init(base64Encoded: self, options: .ignoreUnknownCharacters)
        } else {
            data = self.getDataWithHexString()
        }
        if data == nil || data!.isEmpty { return nil }
        let keyData = keyString.data(using: .utf8)!
        var ivData : NSData? = nil
        if iv != nil && iv!.isEmpty == false {
            ivData = NSData.init(data: iv!.data(using: .utf8)!)
        }
        let resultData = data?.deCrypt(algorithm: algorithm, keyData: NSData.init(data: keyData), iv: ivData)
        if resultData == nil || resultData!.isEmpty { return nil }
        let resultString = String.init(data: Data(resultData!), encoding: .utf8)
        return resultString
    }
}

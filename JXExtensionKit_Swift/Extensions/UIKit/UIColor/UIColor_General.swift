//
//  UIColor_General.swift
//  JXExtensionKit_Swift
//
//  Created by Barnett on 2020/8/27.
//  Copyright © 2020 Barnett. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    // 色值，0.0 ~ 1.0
    var redValue : CGFloat {
        get{
            var r : CGFloat = 0
            self.getRed(&r, green: nil, blue: nil, alpha: nil)
            return r
        }
    }
    var greenValue : CGFloat {
        get {
            var g : CGFloat = 0
            self.getRed(nil, green: &g, blue: nil, alpha: nil)
            return g
        }
    }
    var blueValue : CGFloat {
        get {
            var b : CGFloat = 0
            self.getRed(nil, green: nil, blue: &b, alpha: nil)
            return b
        }
    }
    var alphaValue : CGFloat {
        get {
            return self.cgColor.alpha
        }
    }
    
    // MARK: iOS 13.0 之后颜色设置
    /// iOS 13.0 亮暗颜色设置
    /// - Parameters:
    ///   - lightColor: 浅色模式时颜色
    ///   - darkColor: 深色模式时颜色
    class func colorWithLight(_ lightColor : UIColor,darkColor : UIColor) -> UIColor {
        if #available(iOS 13.0, *) {
            let dynamicColor = UIColor.init { (traitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == UIUserInterfaceStyle.light {
                    return lightColor
                } else if traitCollection.userInterfaceStyle == UIUserInterfaceStyle.dark {
                    return darkColor
                } else {
                    return lightColor
                }
            }
            return dynamicColor
        } else {
            return lightColor
        }
    }
    
    /// 传入十进制颜色生成UIColor
    /// - Parameters:
    ///   - red: 0~255
    ///   - green: 0~255
    ///   - blue: 0~255
    ///   - alpha: 0~1.0
    class func colorFromRed(_ red : CGFloat,green : CGFloat,blue : CGFloat,alpha : CGFloat) -> UIColor {
        return UIColor.init(red: red / 255.0, green: red / 255.0, blue: red / 255.0, alpha: alpha)
    }
    
    // MARK: 十六进制
    /// 传入十六进制颜色 返回UIColor
    /// - Parameter rgbaValue: 0xffFFB6C1
    class func colorFromRGBA(rgbaValue : UInt32) -> UIColor {
        let r : CGFloat = CGFloat((rgbaValue & 0xFF000000) >> 24)
        let g : CGFloat = CGFloat((rgbaValue & 0xFF0000) >> 16)
        let b : CGFloat = CGFloat((rgbaValue & 0xFF00) >> 8)
        let a : CGFloat = CGFloat((rgbaValue & 0xFF))
        return UIColor.colorFromRed(r, green: g, blue: b, alpha: a/255.0)
    }
    
    /// 传入十六进制颜色 返回UIColor
    /// - Parameter rgbaValue: 0x66ccff
    class func colorFromRGB(rgbaValue : UInt32) -> UIColor {
        let r : CGFloat = CGFloat((rgbaValue & 0xFF000000) >> 24)
        let g : CGFloat = CGFloat((rgbaValue & 0xFF0000) >> 16)
        let b : CGFloat = CGFloat((rgbaValue & 0xFF00) >> 8)
        return UIColor.colorFromRed(r, green: g, blue: b, alpha: 1.0)
    }
    
    /// 传入十六进制颜色 和 透明度 返回UIColor
    /// - Parameters:
    ///   - rgbaValue: 0x66ccff
    ///   - alpha: 0~1
    class func colorFromRGB(rgbaValue : UInt32,alpha : CGFloat) -> UIColor {
        let r : CGFloat = CGFloat((rgbaValue & 0xFF000000) >> 24)
        let g : CGFloat = CGFloat((rgbaValue & 0xFF0000) >> 16)
        let b : CGFloat = CGFloat((rgbaValue & 0xFF00) >> 8)
        return UIColor.colorFromRed(r, green: g, blue: b, alpha: alpha)
    }
    
    /// 传入十六进制字符串色值 返回UIColor
    /// - Parameters:
    ///   - hexStr: @"0xF0F", @"66ccff", @"#66CCFF88"
    ///   - alpha: 透明度，-1时表示取 hexStr 中透明度
    class func colorFromHexString(hexStr : String,alpha : Float) -> UIColor? {
        var r : CGFloat = 0,g : CGFloat = 0,b : CGFloat = 0,a : CGFloat = 0;
        if UIColor.p_hexStrToRGBA(rgbaValue: hexStr, r: &r, g: &g, b: &b, a: &a) {
            if alpha == -1 {
                return UIColor.init(red: r, green: g, blue: b, alpha: a)
            }
            return UIColor.init(red: r, green: g, blue: b, alpha: CGFloat(alpha))
        }
        return nil
    }
    
    /// 传入十六进制字符串色值（透明度默认为1）生成UIColor
    /// - Parameter hexStr: 例：@"ededed"
    /// - Returns: 颜色
    class func colorFromHexString(hexStr : String) -> UIColor? {
        return self.colorFromHexString(hexStr: hexStr, alpha: 1.0)
    }
    
    /// 返回十六进制的rgba字符串值，例：0xffff0000
    /// - Returns: 颜色
    func rgbaHexString() -> String? {
        return self.p_hexStringWithAlpha(isAlpha: true)
    }
    
    /// 返回十六进制的rgb字符串值，例：#ff0000
    /// - Returns: 颜色
    func rgbHexString() -> String? {
        return self.p_hexStringWithAlpha(isAlpha: false)
    }
    
    // MARK: 私有方法
    private func p_hexStringWithAlpha(isAlpha : Bool) -> String? {
        let cgColor = self.cgColor
        let count = cgColor.components?.count
        let components = cgColor.components
        let stringFormat = "%02x%02x%02x"
        var hex : String? = nil
        if count == 2 {
            let white : UInt = UInt(components![0] * 255.0)
            hex = String.init(format: stringFormat, white,white,white)
        } else {
            let red : UInt = UInt(components![0] * 255.0)
            let green : UInt = UInt(components![1] * 255.0)
            let blue : UInt = UInt(components![2] * 255.0)
            hex = String.init(format: stringFormat, red,green,blue)
        }
        if hex != nil && isAlpha {
            hex = hex! + String.init(format: "%02lx", self.cgColor.alpha + 0.5)
        }
        return hex
    }
    
    private class func p_hexStrToRGBA(rgbaValue : String,r : UnsafeMutablePointer<CGFloat>?,g : UnsafeMutablePointer<CGFloat>?,b : UnsafeMutablePointer<CGFloat>?,a : UnsafeMutablePointer<CGFloat>?) -> Bool {
        let set = NSCharacterSet.whitespacesAndNewlines
        var rgbaString = rgbaValue.trimmingCharacters(in: set).uppercased()
        
        if rgbaString.hasPrefix("#") {
            rgbaString = String(rgbaString[rgbaString.index(rgbaString.startIndex, offsetBy: 1)...rgbaString.endIndex])
        } else if rgbaString.hasPrefix("0X") {
            rgbaString = String(rgbaString[rgbaString.index(rgbaString.startIndex, offsetBy: 2)...rgbaString.endIndex])
        }
        
        let length = rgbaString.count
        if length != 3 && length != 4 && length != 6 && length != 8 {
            return false
        }
        if length < 5 {
            let rString = String(rgbaString[rgbaString.index(rgbaString.startIndex, offsetBy: 0)])
            r?.pointee = CGFloat(self.p_hexStringToInt(content: rString)) / 255.0
            let gString = String(rgbaString[rgbaString.index(rgbaString.startIndex, offsetBy: 1)])
            g?.pointee = CGFloat(self.p_hexStringToInt(content: gString)) / 255.0
            let bString = String(rgbaString[rgbaString.index(rgbaString.startIndex, offsetBy: 2)])
            b?.pointee = CGFloat(self.p_hexStringToInt(content: bString)) / 255.0
            if length == 4 {
                let aString = String(rgbaString[rgbaString.index(rgbaString.startIndex, offsetBy: 3)])
                a?.pointee = CGFloat(self.p_hexStringToInt(content: aString)) / 255.0
            } else {
                a?.pointee = 1.0
            }
        } else {
            let rString = String(rgbaString[rgbaString.startIndex..<rgbaString.index(rgbaString.startIndex, offsetBy: 2)])
            r?.pointee = CGFloat(self.p_hexStringToInt(content: rString)) / 255.0
            let gString = String(rgbaString[rgbaString.index(rgbaString.startIndex, offsetBy: 2)..<rgbaString.index(rgbaString.startIndex, offsetBy: 4)])
            g?.pointee = CGFloat(self.p_hexStringToInt(content: gString)) / 255.0
            let bString = String(rgbaString[rgbaString.index(rgbaString.startIndex, offsetBy: 4)..<rgbaString.index(rgbaString.startIndex, offsetBy: 6)])
            b?.pointee = CGFloat(self.p_hexStringToInt(content: bString)) / 255.0
            if length == 8 {
                let aString = String(rgbaString[rgbaString.index(rgbaString.startIndex, offsetBy: 6)..<rgbaString.index(rgbaString.startIndex, offsetBy: 8)])
                a?.pointee = CGFloat(self.p_hexStringToInt(content: aString)) / 255.0
            } else {
                a?.pointee = 1.0
            }
        }
        return true
    }
    
    private class func p_hexStringToInt(content : String) -> UInt {
        var result : UInt32 = 0
        Scanner.init(string: content).scanHexInt32(&result)
        return UInt(result)
    }
}

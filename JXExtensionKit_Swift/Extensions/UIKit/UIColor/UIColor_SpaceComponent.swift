//
//  UIColor_SpaceComponent.swift
//  JXExtensionKit_Swift
//
//  Created by Barnett on 2020/9/1.
//  Copyright © 2020 Barnett. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    var hue : CGFloat {
        get {
            var h : CGFloat = 0
            self.getHue(&h, saturation: nil, brightness: nil, alpha: nil)
            return h
        }
    }
    var saturation : CGFloat {
        get {
            var s : CGFloat = 0
            self.getHue(nil, saturation: &s, brightness: nil, alpha: nil)
            return s
        }
    }
    var brightness : CGFloat {
        get {
            var b : CGFloat = 0
            self.getHue(nil, saturation: nil, brightness: &b, alpha: nil)
            return b
        }
    }
    /// 颜色空间模型
    var colorSpaceModel : CGColorSpaceModel {
        get {
            return self.cgColor.colorSpace!.model
        }
    }
    /// 可读的色彩空间字符串。
    var colorSpaceString : String {
        get {
            let model = self.cgColor.colorSpace!.model
            switch model {
            case .unknown:
                return "kCGColorSpaceModelUnknown"
            case .monochrome:
                return "kCGColorSpaceModelMonochrome"
            case .rgb:
                return "kCGColorSpaceModelRGB"
            case .cmyk:
                return "kCGColorSpaceModelCMYK"
            case .lab:
                return "kCGColorSpaceModelLab"
            case .deviceN:
                return "kCGColorSpaceModelDeviceN"
            case .indexed:
                return "kCGColorSpaceModelIndexed"
            case .pattern:
                return "kCGColorSpaceModelPattern"
            default:
                return "ColorSpaceInvalid"
            }
        }
    }
    
    // MARK:HSL
    /// 根据 HSL 创建返回
    /// - Parameters:
    ///   - hue: hue 色相分量 0 - 1.0
    ///   - saturation: 饱和度分量 0 - 1.0
    ///   - lightness: 亮度分量 0 - 1.0
    ///   - alpha: 透明度 0 - 1.0
    class func colorWithHue(hue : CGFloat,saturation : CGFloat,lightness : CGFloat,alpha : CGFloat) -> UIColor? {
        var r : CGFloat = 0
        var g : CGFloat = 0
        var b : CGFloat = 0
        
        if UIColor.p_HSLToRGBWithHue(hue: hue, saturation: saturation, lightness: lightness, red: &r, green: &g, blue: &b) {
            return UIColor.colorFromRed(r, green: g, blue: b, alpha: alpha)
        }
        return nil
    }
    
    /// 修改 HSL 返回新的
    /// - Parameters:
    ///   - hueDelta: hueDelta 增加或者减小的值
    func colorByChangeHue(hueDelta : CGFloat,saturationDelta : CGFloat,brightnessDelta : CGFloat,alphaDelta: CGFloat) -> UIColor? {
        var hh : CGFloat = 0
        var ss : CGFloat = 0
        var bb : CGFloat = 0
        var aa : CGFloat = 0
        if !self.getHue(&hh, saturation: &ss, brightness: &bb, alpha: &aa) {
            return self
        }
        hh += hueDelta
        ss += saturationDelta
        bb += brightnessDelta
        aa += alphaDelta
        hh -= CGFloat(Int(hh));
        hh = hh < 0 ? hh + 1 : hh
        ss = ss < 0 ? 0 : ss > 1 ? 1 : ss
        bb = bb < 0 ? 0 : bb > 1 ? 1 : bb
        aa = aa < 0 ? 0 : aa > 1 ? 1 : aa
        return UIColor.colorWithHue(hue: hh, saturation: ss, lightness: bb, alpha: aa)
    }
    
    // MARK:CMYK
    /// CMYK颜色空间分量值创建并返回颜色对象。
    /// - Parameters:
    ///   - cyan: 青色 0 - 1.0
    ///   - magenta: 洋红色 0 - 1.0
    ///   - yellow: 黄色 0 - 1.0
    ///   - black: 黑色 0 - 1.0
    ///   - alpha: 透明度 0 - 1.0
    class func colorWithCyan(cyan : CGFloat,magenta : CGFloat,yellow : CGFloat,black : CGFloat,alpha : CGFloat) -> UIColor? {
        var r : CGFloat = 0
        var g : CGFloat = 0
        var b : CGFloat = 0
        UIColor.p_CMYKToRGBWithCyan(cyan: cyan, magenta: magenta, yellow: yellow, black: black, red: &r, green: &g, blue: &b)
        return UIColor.colorFromRed(r, green: g, blue: b, alpha: alpha)
    }
    
    /// 获取组成CMYK颜色空间中颜色的成分。
    func getCyan(cyan : UnsafeMutablePointer<CGFloat>?,magenta : UnsafeMutablePointer<CGFloat>?,yellow : UnsafeMutablePointer<CGFloat>?,black : UnsafeMutablePointer<CGFloat>?,alpha : UnsafeMutablePointer<CGFloat>?) -> Bool {
        var r : CGFloat = 0
        var g : CGFloat = 0
        var b : CGFloat = 0
        var a : CGFloat = 0
        if !self.getRed(&r, green: &g, blue: &b, alpha: &a) {
            return false
        }
        UIColor.p_RGBToCMYKWithRed(red: r, green: g, blue: b, cyan: cyan, magenta: magenta, yellow: yellow, black: black)
        alpha?.pointee = a
        return true
    }
    
    // MARK: 私有方法
    private class func CLAMP_COLOR_VALUE(v : CGFloat) -> CGFloat {
        let result = v < 0 ? 0 : v > 1 ? 1 : v;
        return result
    }
    private class func p_HSLToRGBWithHue(hue : CGFloat,saturation : CGFloat,lightness : CGFloat,red : UnsafeMutablePointer<CGFloat>?,green : UnsafeMutablePointer<CGFloat>?,blue : UnsafeMutablePointer<CGFloat>?) -> Bool {
        var h = CLAMP_COLOR_VALUE(v: hue)
        
        if saturation == 0 { // 无饱和度，色相不确定（无色）
            red?.pointee = lightness;
            green?.pointee = lightness;
            blue?.pointee = lightness;
            return false
        }
        var q : CGFloat = 0
        q = (lightness <= 0.5) ? (lightness * (1 + saturation)) : (lightness + saturation - (lightness * saturation))
        if q <= 0 {
            red?.pointee = 0;
            green?.pointee = 0;
            blue?.pointee = 0;
        } else {
            red?.pointee = 0;
            green?.pointee = 0;
            blue?.pointee = 0;
            
            var sextant : Int = 0
            var m : CGFloat = 0
            var sv : CGFloat = 0
            var fract : CGFloat = 0
            var vsf : CGFloat = 0
            var mid1 : CGFloat = 0
            var mid2 : CGFloat = 0
            m = lightness + lightness - q
            sv = (q - m) / q
            if h == 1 {
                h = 0
            }
            h *= 6.0
            sextant = Int(hue)
            fract = h - CGFloat(sextant)
            vsf = q * sv * fract;
            mid1 = m + vsf;
            mid2 = q - vsf;
            switch sextant {
            case 0:
                red?.pointee = q
                green?.pointee = mid1
                blue?.pointee = m
                break
            case 1:
                red?.pointee = mid2
                green?.pointee = q
                blue?.pointee = m
                break
            case 2:
                red?.pointee = m
                green?.pointee = q
                blue?.pointee = mid1
                break
            case 3:
                red?.pointee = m
                green?.pointee = mid2
                blue?.pointee = q
                break
            case 4:
                red?.pointee = mid1
                green?.pointee = m
                blue?.pointee = q
                break
            case 5:
                red?.pointee = q
                green?.pointee = m
                blue?.pointee = mid2
                break
            default:
                return false
            }
        }
        return true
    }
    private class func p_CMYKToRGBWithCyan(cyan : CGFloat,magenta : CGFloat,yellow : CGFloat,black : CGFloat,red : UnsafeMutablePointer<CGFloat>?,green : UnsafeMutablePointer<CGFloat>?,blue : UnsafeMutablePointer<CGFloat>?) {
        let c = CLAMP_COLOR_VALUE(v: cyan)
        let m = CLAMP_COLOR_VALUE(v: magenta)
        let y = CLAMP_COLOR_VALUE(v: yellow)
        let k = CLAMP_COLOR_VALUE(v: black)
        
        red?.pointee = (1 - c) * (1 - k)
        green?.pointee = (1 - m) * (1 - k)
        blue?.pointee = (1 - y) * (1 - k)
    }
    private class func p_RGBToCMYKWithRed(red : CGFloat,green : CGFloat,blue : CGFloat,cyan : UnsafeMutablePointer<CGFloat>?,magenta : UnsafeMutablePointer<CGFloat>?,yellow : UnsafeMutablePointer<CGFloat>?,black : UnsafeMutablePointer<CGFloat>?) {
        let r = CLAMP_COLOR_VALUE(v: red)
        let g = CLAMP_COLOR_VALUE(v: green)
        let b = CLAMP_COLOR_VALUE(v: blue)

        cyan?.pointee = 1 - r
        magenta?.pointee = 1 - g
        yellow?.pointee = 1 - b
        black?.pointee = fmin(cyan!.pointee, fmin(magenta!.pointee, yellow!.pointee))
        
        if black?.pointee == 1 {
            cyan?.pointee = 0
            magenta?.pointee = 0
            yellow?.pointee = 0
        } else {
            cyan?.pointee = (cyan!.pointee - black!.pointee) / (1 - black!.pointee);
            magenta?.pointee = (magenta!.pointee - black!.pointee) / (1 - black!.pointee);
            yellow?.pointee = (yellow!.pointee - black!.pointee) / (1 - black!.pointee);
        }
    }
    
}

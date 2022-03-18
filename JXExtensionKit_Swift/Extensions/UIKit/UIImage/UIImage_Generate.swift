//
//  UIImage_Generate.swift
//  JXExtensionKit_Swift
//
//  Created by Barnett on 2020/7/10.
//  Copyright © 2020 Barnett. All rights reserved.
//

import Foundation
import UIKit
import Accelerate

enum JXTriangleDirection { // 生成三角图片方向
    case Down
    case Left
    case Right
    case Up
}

extension UIImage
{
    // MARK:类方法
    /// 生成带圆角的颜色图片
    /// - Parameters:
    ///   - color: 图片颜色
    ///   - targetSize: 生成尺寸
    ///   - roundingCorners: 圆角位置
    ///   - cornerRadius: 圆角大小，默认为0
    ///   - backgroundColor: 背景颜色，默认白色
    class func cornerRadiusImageWith(tintColor:UIColor,targetSize:CGSize,roundingCorners:UIRectCorner? = UIRectCorner.allCorners, cornerRadius:CGFloat = 0,backgroundColor:UIColor? = UIColor.white) -> UIImage? {
        
        let targetRect = CGRect.init(x: 0, y: 0, width: targetSize.width, height: targetSize.height)
        
        UIGraphicsBeginImageContextWithOptions(targetSize, true, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(tintColor.cgColor)
        context?.fill(targetRect)
        var finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if cornerRadius == CGFloat.zero {
            // 未设置圆角即可返回
            return finalImage
        }
    
        UIGraphicsBeginImageContextWithOptions(targetSize, true, UIScreen.main.scale)
        let newContext = UIGraphicsGetCurrentContext()
        backgroundColor?.setFill()
        newContext?.fill(targetRect)
        let path = UIBezierPath.init(roundedRect: targetRect, byRoundingCorners: roundingCorners!, cornerRadii: CGSize.init(width: cornerRadius, height: cornerRadius))
        newContext?.addPath(path.cgPath)
        newContext?.clip()
        finalImage?.draw(in: targetRect)
        finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return finalImage
    }
    
    /// 生成矩形的颜色图片
    class func squareImageWith(tintColor:UIColor,targetSize:CGSize) -> UIImage? {
        return UIImage.cornerRadiusImageWith(tintColor: tintColor, targetSize: targetSize, roundingCorners: nil, cornerRadius: 0, backgroundColor: UIColor.white)
    }
    
    /// 生成带圆角的颜色图片,背景默认白色
    func cornerRadiusImageWith(tintColor:UIColor,targetSize:CGSize,cornerRadius:CGFloat = 0) -> UIImage? {
        return UIImage.cornerRadiusImageWith(tintColor: tintColor, targetSize: targetSize, roundingCorners: UIRectCorner.allCorners, cornerRadius: cornerRadius, backgroundColor: UIColor.white)
    }
    
    /// 生成渐变色的UIImage
    /// - Parameters:
    ///   - size: 尺寸
    ///   - colors: 颜色数组
    ///   - startP: 开始坐标
    ///   - endP: 结束坐标
    class func gradientColorImageWithSize(_ size:CGSize,colors:Array<UIColor>,startP:CGPoint,endP:CGPoint) -> UIImage? {
        var cgColorArr = Array<CGColor>.init()
        
        for color in colors {
            cgColorArr.append(color.cgColor)
        }
        
        UIGraphicsBeginImageContextWithOptions(size, true, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        let colorSpace = colors.last?.cgColor.colorSpace
        let gradient = CGGradient.init(colorsSpace: colorSpace, colors: cgColorArr as CFArray, locations: nil)!
        
        context?.drawLinearGradient(gradient, start: startP, end: endP, options: (CGGradientDrawingOptions.drawsBeforeStartLocation))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        context?.restoreGState()
        UIGraphicsEndImageContext()
        return image
    }
    
    /// 生成三角图片
    /// - Parameters:
    ///   - size: 尺寸
    ///   - color: 颜色
    ///   - direction: 三角方向
    class func triangleImageWithSize(_ size:CGSize,color:UIColor,direction:JXTriangleDirection) -> UIImage? {
        let scale = UIScreen.main.scale
        let newSize = CGSize.init(width: size.width*scale, height: size.height*scale)
        
        let squareImage = UIImage.cornerRadiusImageWith(tintColor: color, targetSize: newSize)
        UIGraphicsBeginImageContext(newSize)
        let context = UIGraphicsGetCurrentContext()
       
        var sPoints:Array<CGPoint> = Array.init()
        switch direction {
        case .Down:
            sPoints.append(CGPoint.init(x: 0, y: 0))
            sPoints.append(CGPoint.init(x: newSize.width, y: 0))
            sPoints.append(CGPoint.init(x: newSize.width/2, y: newSize.height))
            break
        case .Up:
            sPoints.append(CGPoint.init(x: newSize.width/2, y: 0))
            sPoints.append(CGPoint.init(x: 0, y: newSize.height))
            sPoints.append(CGPoint.init(x: newSize.width, y: newSize.height))
            break
        case .Left:
            sPoints.append(CGPoint.init(x: newSize.width, y: 0))
            sPoints.append(CGPoint.init(x: 0, y: newSize.height/2))
            sPoints.append(CGPoint.init(x: newSize.width, y: newSize.height))
            break
        case .Right:
            sPoints.append(CGPoint.init(x: 0, y: 0))
            sPoints.append(CGPoint.init(x: 0, y: newSize.height))
            sPoints.append(CGPoint.init(x: newSize.width, y: newSize.height/2))
            break
        }
        context?.addLines(between: sPoints)
        context?.closePath()
        context?.clip()
        squareImage?.draw(in: CGRect.init(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resultImage
    }

    
    /// 从苹果表情符号创建图像
    /// - Parameters:
    ///   - emoji: 表情符号
    ///   - size: 尺寸
    class func emojiImageWith(emoji:String,size:Double) -> UIImage? {
        
        if emoji.count <= 0 || size < 1.0 {
            return nil
        }
        let scale = UIScreen.main.scale
        let ctFont = CTFontCreateWithName("AppleColorEmoji" as CFString, CGFloat(size) * scale, nil)
        
        let fontName = CTFontCopyName(ctFont, kCTFontPostScriptNameKey)! as String
        let fontSize = CTFontGetSize(ctFont)
        let font = UIFont.init(name: fontName, size: fontSize)
        if font == nil {
            return nil
        }
        let attributedString = NSAttributedString.init(string: emoji, attributes: [NSAttributedString.Key.font:font!,NSAttributedString.Key.foregroundColor:UIColor.white])
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let ctx = CGContext.init(data: nil, width: Int(CGFloat(size) * scale), height: Int(CGFloat(size) * scale), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)
        ctx?.interpolationQuality = CGInterpolationQuality.high
        let line = CTLineCreateWithAttributedString(attributedString)
        let bounds = CTLineGetBoundsWithOptions(line, CTLineBoundsOptions.useGlyphPathBounds)
        ctx?.textPosition = CGPoint.init(x: 0, y: -bounds.origin.y)
        CTLineDraw(line, ctx!)
        let imageRef = ctx?.makeImage()
        let image = UIImage.init(cgImage: imageRef!, scale: scale, orientation: .up)
        return image
    }
    
    /// 图像绘制block
    /// - Parameters:
    ///   - imageSize: 尺寸
    ///   - drawBlock: 绘制回调
    class func drawImage(imageSize:CGSize,drawBlock:((_ context:CGContext) -> Void)?) -> UIImage? {
        if drawBlock == nil {
            return nil
        }
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
        let context = UIGraphicsGetCurrentContext()
        if context == nil {
            return nil
        }
        drawBlock!(context!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

//
//  UIImage_Clip.swift
//  JXExtensionKit_Swift
//
//  Created by Barnett on 2020/7/10.
//  Copyright © 2020 Barnett. All rights reserved.
//

import Foundation
import UIKit

extension UIImage
{
    /// 裁剪为有边界的圆形图片
    /// - Parameters:
    ///   - borderWidth: 边界宽度
    ///   - borderColor: 边界颜色
    func clipImageWithBorderWidth(borderWidth:CGFloat? = 0.0,borderColor:UIColor? = UIColor.clear) -> UIImage? {
        let imageWH = self.size.width > self.size.height ? self.size.height : self.size.width
        let circleWidth = borderWidth!
        let newImageWH = imageWH + 2*circleWidth
        
        UIGraphicsBeginImageContextWithOptions(CGSize.init(width: newImageWH, height: newImageWH), false, UIScreen.main.scale)
        let path = UIBezierPath.init(ovalIn: CGRect.init(x: 0, y: 0, width: newImageWH, height: newImageWH))
        borderColor!.set()
        path.fill()
        
        let clipPath = UIBezierPath.init(ovalIn: CGRect.init(x: circleWidth, y: circleWidth, width: imageWH, height: imageWH))
        clipPath.addClip()
        
        self.draw(at: CGPoint.init(x: circleWidth, y: circleWidth))
        let clipImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return clipImage
    }
    
    /// 裁剪图片中的一块区域
    /// - Parameter clipRect: 裁剪区域
    func imageClipRect(clipRect:CGRect) -> UIImage? {
        let imageSize = self.size
        if clipRect.origin.x > imageSize.width || clipRect.origin.y > imageSize.height {
            return nil
        }
        var newClipRect = clipRect
        
        if clipRect.origin.x + clipRect.size.width > imageSize.width {
            newClipRect.size.width = imageSize.width - clipRect.origin.x
        }
        if clipRect.origin.y + clipRect.size.height > imageSize.height {
            newClipRect.size.height = imageSize.height - clipRect.origin.y
        }
        let newImage = UIImage.init(cgImage: self.cgImage!.cropping(to: newClipRect)!)
        
        return newImage
    }
    
    /// 拉伸图片
    /// - Parameters:
    ///   - edgeInsets: 不进行拉伸的区域
    ///   - model: tile  -  平铺（图片小于imageView大小时，左上角显示的第一个图片不变，imageview其余部位使用图片不拉伸区域裁剪后铺满），stretch  -  拉伸（图片撑满imageview,不拉伸区域根据设置）
    func resizableImage(edgeInsets:UIEdgeInsets,model:UIImage.ResizingMode) -> UIImage? {
        let image = self.resizableImage(withCapInsets: edgeInsets, resizingMode: model)
        return image
    }
    
    /// 拉伸图片，创建一个内容可拉伸，而边角不拉伸的图片，需要两个参数，第一个是左边不拉伸区域的宽度，第二个参数是上面不拉伸的高度。那么接下来的一个像素会被拉伸。例如，leftCapHeight为6，topCapHeight为8。那么，图片左边的6个像素，上边的8个像素。不会被拉伸，而左边的第7个像素，上边的第9个像素这一块区域将会被拉伸。剩余的部分也不会被拉伸。***这个方法只能拉伸1x1的区域***
    /// - Parameters:
    ///   - left: 左边距
    ///   - top: 右边距
    func stretchableImage(left:NSInteger,top:NSInteger) -> UIImage? {
        let image = self.stretchableImage(withLeftCapWidth: left, topCapHeight: top)
        return image
    }
    
    /// 改变图片尺寸
    /// - Parameters:
    ///   - newSize: 新尺寸
    ///   - isScale: 是否按照比例转换
    func changeSize(newSize:CGSize,isScale:Bool) -> UIImage? {
        var newImage : UIImage?
        if isScale {
            var width : CGFloat = CGFloat(self.cgImage!.width)
            var height : CGFloat = CGFloat(self.cgImage!.height)
            
            let verticalRadio = newSize.height / height
            let horizontalRadio = newSize.width / width
            
            var radio : CGFloat = 1.0
            if verticalRadio > 1.0 && horizontalRadio > 1.0 {
                radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio
            }else
            {
                radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio
            }
            width = width * radio
            height = height * radio
            
            let xPos = (newSize.width - width) / 2
            let yPos = (newSize.height - height) / 2
            
            // 创建一个bitmap的context
            // 并把它设置成为当前正在使用的context
            UIGraphicsBeginImageContext(newSize)
            // 绘制改变大小的图片
            self.draw(in: CGRect.init(x: xPos, y: yPos, width: width, height: height))
            // 从当前context中创建一个改变大小后的图片
            newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }else
        {
            //根据当前大小创建一个基于位图图形的环境
            UIGraphicsBeginImageContext(newSize)
            self.draw(in: CGRect.init(x: 0, y: 0, width: newSize.width, height: newSize.height))
            newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        return newImage
    }
    
    /// 裁剪图片圆角
    /// - Parameters:
    ///   - targetSize: 目标尺寸
    ///   - cornerRadius: 圆角尺寸
    ///   - corners: 圆角方位
    ///   - backgroundColor: 裁剪后圆角的背景颜色
    ///   - isEqualScale: 是否等比缩放
    func clipCornerImage(targetSize:CGSize?=CGSize.zero,
                         cornerRadius:CGFloat?=0.0,
                         corners:UIRectCorner?=UIRectCorner.allCorners,
                         backgroundColor:UIColor?=UIColor.white,
                         isEqualScale:Bool?=false) -> UIImage? {
        if Double(targetSize!.width) <= 0.0 || Double(targetSize!.height) <= 0.0 {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(targetSize!, true, UIScreen.main.scale)
        let imgSize = self.size
        var resultSize = targetSize
        
        if isEqualScale! {
            let x = CGFloat.maximum(targetSize!.width / imgSize.width, targetSize!.height / imgSize.height)
            resultSize = CGSize.init(width: x * imgSize.width, height: x * imgSize.height)
        }
        let targetRect = CGRect.init(x: 0, y: 0, width: resultSize!.width, height: resultSize!.height)
        
        backgroundColor?.setFill()
        UIGraphicsGetCurrentContext()?.fill(targetRect)
        
        if cornerRadius! > CGFloat(0.0) {
            let path = UIBezierPath.init(roundedRect: targetRect, byRoundingCorners: corners!, cornerRadii: CGSize.init(width: cornerRadius!, height: cornerRadius!))
            UIGraphicsGetCurrentContext()?.addPath(path.cgPath)
            UIGraphicsGetCurrentContext()?.clip()
        }
        self.draw(in: targetRect)
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return finalImage
    }
    
    /// 裁剪为全圆角图片
    /// - Parameter cornerRadius: 圆角大小
    func clipAllCornersImage(cornerRadius:CGFloat) -> UIImage? {
        return self.clipCornerImage(targetSize: self.size, cornerRadius: cornerRadius, corners: UIRectCorner.allCorners, backgroundColor: UIColor.white, isEqualScale: true)
    }
    
    /// 裁剪为圆角图片
    /// - Parameters:
    ///   - cornerRadius: 圆角大小
    ///   - corners: 圆角位置
    func clipToCornerImage(cornerRadius:CGFloat,corners:UIRectCorner) -> UIImage? {
        return self.clipCornerImage(targetSize: self.size, cornerRadius: cornerRadius, corners: corners, backgroundColor: UIColor.white, isEqualScale: true)
    }
}

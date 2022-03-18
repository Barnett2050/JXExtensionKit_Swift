//
//  UIImage_General.swift
//  JXExtensionKit_Swift
//
//  Created by Barnett on 2020/7/10.
//  Copyright © 2020 Barnett. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    /// 图片是否有透明
    var hasAlphaChannel : Bool? {
        get {
            if self.cgImage == nil {
                return nil
            }
            let alpha = self.cgImage!.alphaInfo.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
            return (alpha == CGImageAlphaInfo.first.rawValue ||
                    alpha == CGImageAlphaInfo.last.rawValue ||
                    alpha == CGImageAlphaInfo.premultipliedFirst.rawValue ||
                    alpha == CGImageAlphaInfo.premultipliedLast.rawValue)
        }
    }
    
    /// 转换图片为png格式的base64编码
    var base64String : String? {
        get {
            if self.cgImage == nil {
                return nil
            }
            let data = self.pngData()
            let encodedData = Data.init(base64Encoded: data!, options: .ignoreUnknownCharacters)
            let string = String.init(data: encodedData!, encoding: .utf8)
            return string
        }
    }
    
    // MARK:实例方法
    /// 更新图片的方向，直立显示
    /// - Returns: 图片
    func updateImageOrientation() -> UIImage? {
        if self.cgImage == nil {
            return nil
        }
        if self.imageOrientation == UIImage.Orientation.up {
            return self
        }
        var transform = CGAffineTransform.identity
        let orientation = self.imageOrientation
        
        switch orientation {
        case .down,.downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: CGFloat.pi)
        case .left,.leftMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi/2)
        case .right,.rightMirrored:
            transform = transform.translatedBy(x: 0, y: self.size.height)
            transform = transform.rotated(by: -CGFloat.pi/2)
        default: break
        }
        switch orientation {
        case .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored,.rightMirrored:
            transform = transform.translatedBy(x: 0, y: self.size.height)
            transform = transform.scaledBy(x: -1, y: 1)
        default:
            break
        }
        let ctx = CGContext.init(data: nil, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: self.cgImage!.bitsPerComponent, bytesPerRow: 0, space: self.cgImage!.colorSpace!, bitmapInfo: self.cgImage!.bitmapInfo.rawValue)
        ctx?.concatenate(transform)
        switch self.imageOrientation {
        case .left,.leftMirrored,.right,.rightMirrored:
            ctx?.draw(self.cgImage!, in: CGRect.init(x: 0, y: 0, width: self.size.height, height: self.size.width))
        default:
            ctx?.draw(self.cgImage!, in: CGRect.init(x: 0, y: 0, width: self.size.width, height: self.size.height))
        }
        let cgimg = ctx?.makeImage()
        let img = UIImage.init(cgImage: cgimg!)
        return img
    }
    
    /// 返回一个旋转图像
    /// - Parameters:
    ///   - radians: 逆时针旋转弧度
    ///   - fitSize: true：扩展新图像的大小以适合所有内容。false：图像的大小不会改变，内容可能会被剪切。
    func imageByRotate(_ radians:CGFloat,fitSize:Bool) -> UIImage? {
        
        let width : CGFloat = CGFloat(self.cgImage!.width)
        let height : CGFloat = CGFloat(self.cgImage!.height)
        
        let rect = CGRect.init(x: 0, y: 0, width: width, height: height)
        let newRect = rect.applying(fitSize ? CGAffineTransform.init(rotationAngle: radians):CGAffineTransform.identity)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let context = CGContext.init(data: nil, width: Int(newRect.size.width), height: Int(newRect.size.height), bitsPerComponent: 8, bytesPerRow: Int(newRect.size.width) * 4, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)
        
        if context == nil {
            return nil
        }
        context!.setShouldAntialias(true)
        context!.setAllowsAntialiasing(true)
        context!.interpolationQuality = CGInterpolationQuality.high
        
        context!.translateBy(x: +(newRect.size.width * 0.5), y: +(newRect.size.height * 0.5))
        context!.rotate(by: radians)
        
        context!.draw(self.cgImage!, in: CGRect.init(x: -(width * 0.5), y: -(height * 0.5), width: width, height: height))
        let cgImage = context!.makeImage()
        let resultImg = UIImage.init(cgImage: cgImage!, scale: self.scale, orientation: self.imageOrientation)
        return resultImg
    }
    
    /// 压缩图片（压缩质量）压缩图片质量的优点在于，尽可能保留图片清晰度，图片不会明显模糊；缺点在于，不能保证图片压缩后小于指定大小。
    /// - Parameter maxSize: 图片大小 需要32kb直接传入32即可
    func compressImageDataDichotomyWith(maxSize:Int) -> Data? {
        var compression : CGFloat = 1.0
        let maxFileSize : CGFloat = 1024.0*CGFloat(maxSize)
        var imageData = self.jpegData(compressionQuality: compression)
        if CGFloat(imageData!.count) < maxFileSize {
            var max : CGFloat = 1.0
            var min : CGFloat = 0.0
            for _ in 0 ..< 6 {
                compression = (max + min) / 2
                imageData = self.jpegData(compressionQuality: compression)
                if CGFloat(imageData!.count) < maxFileSize * 0.9 {
                    min = compression
                } else if CGFloat(imageData!.count) > maxFileSize {
                    max = compression
                } else {
                    break
                }
            }
        }
        return imageData
    }
    
    /// 压缩图片(压缩大小) 压缩后图片明显比压缩质量模糊
    /// - Parameter maxSize: 图片大小 需要32kb直接传入32即可
    func compressImageDataWith(maxSize:Int) -> Data? {
        var resultImage = self
        var imageData = self.jpegData(compressionQuality: 1.0)!
        var lastDataLength = 0
        let maxFileSize : CGFloat = CGFloat(maxSize)*1024.0
        while CGFloat(imageData.count) < maxFileSize && imageData.count != lastDataLength {
            lastDataLength = imageData.count
            let ratio : CGFloat = maxFileSize / CGFloat(imageData.count)
            let size : CGSize = CGSize.init(width: resultImage.size.width * CGFloat(sqrtf(Float(ratio))), height: resultImage.size.height * CGFloat(sqrtf(Float(ratio))))
            
            UIGraphicsBeginImageContext(size)
            // 使用图像绘制(drawInRect:)，图像较大，但压缩时间更长
            // 使用结果图像绘制，图像更小，但压缩时间更短
            resultImage.draw(in: CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
            resultImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            imageData = resultImage.jpegData(compressionQuality: 1)!
        }
        return imageData
    }
    
    /// 压缩图片(两种方法结合)
    /// - Parameter maxSize: 图片大小 需要32kb直接传入32即可
    func compressImageCombineWith(maxSize:Int) -> Data? {
        let maxFileSize : CGFloat = 1024.0 * CGFloat(maxSize)
        var compression : CGFloat = 1.0
        var imageData = self.jpegData(compressionQuality: compression)!
        
        if CGFloat(imageData.count) < maxFileSize {return imageData}
        var max : CGFloat = 1.0
        var min : CGFloat = 0.0
        for _ in 0 ..< 6 {
            compression = (max + min) / 2
            imageData = self.jpegData(compressionQuality: compression)!
            if CGFloat(imageData.count) < maxFileSize * 0.9 {
                min = compression
            } else if CGFloat(imageData.count) > maxFileSize {
                max = compression
            } else {
                break
            }
        }
        if CGFloat(imageData.count) < maxFileSize {return imageData}
        
        var resultImage = UIImage.init(data: imageData)!
        var lastDataLength = 0
        while CGFloat(imageData.count) < maxFileSize && imageData.count != lastDataLength {
            lastDataLength = imageData.count
            let ratio : CGFloat = maxFileSize / CGFloat(imageData.count)
            let size : CGSize = CGSize.init(width: resultImage.size.width * CGFloat(sqrtf(Float(ratio))), height: resultImage.size.height * CGFloat(sqrtf(Float(ratio))))
            
            UIGraphicsBeginImageContext(size)
            // 使用图像绘制(drawInRect:)，图像较大，但压缩时间更长
            // 使用结果图像绘制，图像更小，但压缩时间更短
            resultImage.draw(in: CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
            resultImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            imageData = resultImage.jpegData(compressionQuality: 1)!
        }
        return imageData
        
    }
    
    // MARK:类方法
    /// 根据URL获取尺寸
    class func getImageSizeWithURLString(_ urlString:String?) -> CGSize? {
        if urlString == nil {
            return nil
        }
        let url = NSURL.init(string: urlString!)
        let imageSource = CGImageSourceCreateWithURL(url! as CFURL, nil)
        var width = 0.0,height = 0.0
        
        if imageSource != nil {
            let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource!, 0, nil) as? Dictionary<String, Any>
            if imageProperties != nil {
                width = imageProperties!["PixelWidth"] as? Double ?? 0.0
                height = imageProperties!["PixelHeight"] as? Double ?? 0.0
            }
        }
        return CGSize.init(width: width, height: height)
    }
    
    /// 拼接长图
    /// - Parameters:
    ///   - headImage: 头图
    ///   - footImage: 尾图
    ///   - masterImgArr: 主视图数组
    ///   - edgeMargin: 四周边距
    ///   - imageSpace: 图片间距
    ///   - successBlock: 成功回调
    class func generateLongPictureWith(headImage : UIImage?,footImage : UIImage?,masterImgArr : [UIImage]?,edgeMargin : UIEdgeInsets = UIEdgeInsets.zero,imageSpace : CGFloat = 0,successBlock:((_ longImage : UIImage?,_ totalHeight : CGFloat?) -> Void)?) {
        
        // 主视图不能为空
        if masterImgArr == nil || masterImgArr!.isEmpty {
            if successBlock != nil {
                successBlock!(nil,0)
            }
        }
        
        var totalH : CGFloat = edgeMargin.top
        var headH : CGFloat = 0.0
        var footH : CGFloat = 0.0
        let width = UIScreen.main.bounds.size.width - edgeMargin.left - edgeMargin.right
        
        if headImage != nil {
            let headScale = headImage!.size.height / headImage!.size.width
            headH = headScale * width
            totalH += headH
        }
        if masterImgArr != nil && masterImgArr!.count != 0 {
            for i in 0 ..< masterImgArr!.count {
                let masterImage = masterImgArr![i]
                let masterImgScale = masterImage.size.height / masterImage.size.width
                let masterImgH = masterImgScale * width
                totalH += masterImgH
            }
            totalH += (CGFloat(masterImgArr!.count) * imageSpace)
        }
        if footImage != nil {
            totalH += imageSpace
            let footScale = footImage!.size.height / footImage!.size.width
            footH = footScale * width
            totalH += footH
        }
        totalH += edgeMargin.bottom
        totalH = floor(totalH)
        
        // 绘制画布
        var maxY = edgeMargin.top
        let contextSize = CGSize.init(width: UIScreen.main.bounds.size.width, height: totalH)
        UIGraphicsBeginImageContextWithOptions(contextSize, false, UIScreen.main.scale)
        if headImage != nil {
            headImage?.draw(in: CGRect.init(x: edgeMargin.left, y: maxY, width: width, height: headH))
            maxY += headH
        }
        if masterImgArr != nil && masterImgArr!.count != 0 {
            for i in 0 ..< masterImgArr!.count {
                let masterImage = masterImgArr![i]
                let masterImgScale = masterImage.size.height / masterImage.size.width
                let masterImgH = masterImgScale * width
                
                maxY += imageSpace
                masterImage.draw(in: CGRect.init(x: edgeMargin.left, y: maxY, width: width, height: masterImgH))
                maxY += masterImgH
            }
        }
        if footImage != nil {
            maxY += imageSpace
            footImage?.draw(in: CGRect.init(x: edgeMargin.left, y: maxY, width: width, height: footH))
        }
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if successBlock != nil {
            successBlock!(resultImage,totalH)
        }
    }
}

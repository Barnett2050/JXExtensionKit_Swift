//
//  UIImage_Effect.swift
//  JXExtensionKit_Swift
//
//  Created by Barnett on 2020/7/10.
//  Copyright © 2020 Barnett. All rights reserved.
//

import Foundation
import UIKit
import Accelerate

extension UIImage
{
    // MARK:实例方法
    /// 使用CoreImage技术使图片模糊
    /// - Parameter blurNum: 模糊数值 0~100 （默认100）
    func blurImageWithCoreImageBlurNumber(_ blurNum:CGFloat) -> UIImage? {
        
        let context = CIContext.init()
        guard let oldCGimage = self.cgImage, cgImage != nil else {
            return nil
        }
        let inputImage = CIImage.init(cgImage: oldCGimage)
        // 创建滤镜
        let filter = CIFilter.init(name: "CIGaussianBlur")!
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        filter.setValue(blurNum, forKey: kCIInputRadiusKey)
        let result = filter.value(forKey: kCIOutputImageKey) as! CIImage
        let outImage = context.createCGImage(result, from: CGRect.init(x: 0, y: 0, width: self.size.width, height: self.size.height))!
        let blurImage = UIImage.init(cgImage: outImage)
        return blurImage
    }
    
    /// 使用Accelerate技术模糊图片，模糊效果比CoreImage效果更美观，效率要比CoreImage要高，处理速度快
    /// - Parameter blurValue: 模糊数值 0 ~ 1.0，默认0.1
    func blurImageWithAccelerateBlurValue(_ blurValue:CGFloat) -> UIImage? {
        var newBlurValue : CGFloat = blurValue
        if blurValue < 0.0 {
            newBlurValue = 0.1
        }else if blurValue > 1.0
        {
            newBlurValue = 1.0
        }
        //boxSize必须大于0
        var boxSize = Int(newBlurValue * 100.0)
        boxSize -= (boxSize % 2) + 1
        
        //图像处理
        let imgRef = self.cgImage
        //图像缓存,输入缓存，输出缓存
        var inBuffer = vImage_Buffer()
        var outBuffer = vImage_Buffer()
        var error = vImage_Error()
        let inProvider = imgRef?.dataProvider
        let inBitmapData = inProvider!.data
        
        //宽，高，字节/行，data
        inBuffer.width = vImagePixelCount((imgRef?.width)!)
        inBuffer.height = vImagePixelCount((imgRef?.height)!)
        inBuffer.rowBytes = (imgRef?.bytesPerRow)!
        // void *
        inBuffer.data = UnsafeMutableRawPointer.init(mutating:CFDataGetBytePtr(inBitmapData!))

        // 像素缓存
        let pixelBuffer = malloc(imgRef!.bytesPerRow * imgRef!.height)
        outBuffer.data = pixelBuffer
        outBuffer.width = vImagePixelCount((imgRef?.width)!)
        outBuffer.height = vImagePixelCount((imgRef?.height)!)
        outBuffer.rowBytes = (imgRef?.bytesPerRow)!
        error = vImageBoxConvolve_ARGB8888(&inBuffer,
                                           &outBuffer,
                                           nil,
                                           0,
                                           0,
                                           UInt32(boxSize),
                                           UInt32(boxSize),
                                           nil,
                                           vImage_Flags(kvImageEdgeExtend))
        if(kvImageNoError != error)
        {
            error = vImageBoxConvolve_ARGB8888(&inBuffer,
                                               &outBuffer,
                                               nil,
                                               vImagePixelCount(0),
                                               vImagePixelCount(0),
                                               UInt32(boxSize),
                                               UInt32(boxSize),
                                               nil,
                                               vImage_Flags(kvImageEdgeExtend))
        }
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let ctx = CGContext(data: outBuffer.data,
                            width:Int(outBuffer.width),
                            height:Int(outBuffer.height),
                            bitsPerComponent:8,
                            bytesPerRow: outBuffer.rowBytes,
                            space: colorSpace,
                            bitmapInfo:CGImageAlphaInfo.premultipliedLast.rawValue)
        let imageRef = ctx!.makeImage()
        free(pixelBuffer)
        return UIImage(cgImage: imageRef!)
    }
    
    /// 模糊图片
    /// - Parameters:
    ///   - blurRadius: 模糊半径
    ///   - tintColor: 颜色
    ///   - saturationDeltaFactor: 饱和增量因子 0 图片色为黑白 小于0颜色反转 大于0颜色增深
    ///   - maskImage: 遮罩图像
    /// - Returns: 图片
    func applyBlurWith(blurRadius : Float,tintColor : UIColor?,saturationDeltaFactor : Float,maskImage : UIImage?) -> UIImage? {
        if self.size.width < 1 || self.size.height < 1 || self.cgImage == nil || (maskImage != nil && maskImage!.cgImage == nil) {
            return nil
        }
        let imageRect = CGRect.init(x: 0, y: 0, width: self.size.width, height: self.size.height)
        var effectImage = self
        
        let hasBlur = blurRadius > Float.ulpOfOne
        let hasSaturationChange = fabsf(saturationDeltaFactor - 1.0) > Float.ulpOfOne
        if hasBlur || hasSaturationChange {
            UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
            let effectInContext = UIGraphicsGetCurrentContext()!
            effectInContext.ctm.scaledBy(x: 1, y: -1)
            effectInContext.ctm.translatedBy(x: 0, y: -self.size.height)
            effectInContext.draw(self.cgImage!, in: imageRect)
            
            var effectInBuffer : vImage_Buffer = vImage_Buffer.init()
            effectInBuffer.data = effectInContext.data
            effectInBuffer.rowBytes = effectInContext.bytesPerRow
            effectInBuffer.width = vImagePixelCount(effectInContext.width)
            effectInBuffer.height = vImagePixelCount(effectInContext.height)
            
            UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
            let effectOutContext = UIGraphicsGetCurrentContext()!
            var effectOutBuffer : vImage_Buffer = vImage_Buffer.init()
            
            effectOutBuffer.data = effectOutContext.data
            effectOutBuffer.rowBytes = effectOutContext.bytesPerRow
            effectOutBuffer.width = vImagePixelCount(effectOutContext.width)
            effectOutBuffer.height = vImagePixelCount(effectOutContext.height)
            
            if hasBlur {
                let inputRadius = blurRadius * Float(UIScreen.main.scale)
                var radius = UInt(floorf(inputRadius * 3.0 * sqrtf(2 * Float.pi)/4 + 0.5))
                if radius % 2 != 1 {
                    radius += 1
                }
                vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, UInt32(radius), UInt32(radius), nil, vImage_Flags(kvImageEdgeExtend))
                vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, nil, 0, 0, UInt32(radius), UInt32(radius), nil, vImage_Flags(kvImageEdgeExtend))
                vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, UInt32(radius), UInt32(radius), nil, vImage_Flags(kvImageEdgeExtend))
            }
            
            if hasSaturationChange {
                let s = saturationDeltaFactor
                let floatingPointSaturationMatrix = [0.0722+0.9278 * s,0.0722-0.0722 * s,0.0722-0.0722 * s,0,
                                                     0.7152-0.7152 * s,0.7152+0.2848 * s,0.7152-0.7152 * s,0,
                
                                                     0.2126-0.2126 * s,0.2126-0.2126 * s,0.2126+0.7873 * s,0,
                
                                                     0,0,0,1,]
                let divisor = 256
                let matrixSize = MemoryLayout.size(ofValue: floatingPointSaturationMatrix) / MemoryLayout.size(ofValue: floatingPointSaturationMatrix[0])
                var saturationMatrix : Array<Int16> = Array.init()
                for i in 0 ..< matrixSize {
                    saturationMatrix[i] = Int16(roundf(floatingPointSaturationMatrix[i] * Float(divisor)))
                }
                if hasBlur {
                    vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, Int32(divisor), nil, nil, vImage_Flags(kvImageNoFlags))
                } else {
                    vImageMatrixMultiply_ARGB8888(&effectInBuffer,&effectOutBuffer, saturationMatrix, Int32(divisor), nil, nil, vImage_Flags(kvImageNoFlags));
                }
            }
            effectImage = UIGraphicsGetImageFromCurrentImageContext()!
        }
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
        let outputContext = UIGraphicsGetCurrentContext()
        outputContext?.ctm.scaledBy(x: 1.0, y: -1.0)
        outputContext?.ctm.translatedBy(x: 0, y: -self.size.height)
        outputContext?.draw(self.cgImage!, in: imageRect)
        if hasBlur {
            outputContext?.saveGState()
            if maskImage != nil {
                outputContext?.clip(to: imageRect, mask: maskImage!.cgImage!)
            }
            outputContext?.draw(effectImage.cgImage!, in: imageRect)
            outputContext?.restoreGState()
        }
        if tintColor != nil {
            outputContext?.saveGState()
            outputContext?.setFillColor(tintColor!.cgColor)
            outputContext?.fill(imageRect)
            outputContext?.restoreGState()
        }
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return outputImage
    }
    
    /// 高亮模糊
    func applyLightEffect() -> UIImage? {
        let tintColor = UIColor.init(white: 1.0, alpha: 0.3)
        return self.applyBlurWith(blurRadius: 30, tintColor: tintColor, saturationDeltaFactor: 1.8, maskImage: nil)
    }
    
    /// 轻度亮模糊
    func applyExtraLightEffect() -> UIImage? {
        let tintColor = UIColor.init(white: 0.97, alpha: 0.82)
        return self.applyBlurWith(blurRadius: 20, tintColor: tintColor, saturationDeltaFactor: 1.8, maskImage: nil)
    }
    
    /// 暗色模糊
    func applyDarkEffect() -> UIImage? {
        let tintColor = UIColor.init(white: 0.11, alpha: 0.73)
        return self.applyBlurWith(blurRadius: 20, tintColor: tintColor, saturationDeltaFactor: 1.8, maskImage: nil)
    }
    
    /// 自定义颜色模糊图片
    /// - Parameter tintColor: 影响颜色
    func applyTintEffectWithColor(_ tintColor : UIColor) -> UIImage? {
        let effectColorAlpha : CGFloat = 0.6
        var effectColor = tintColor
        let componentCount = tintColor.cgColor.components
        if componentCount?.count == 2 {
            var b : CGFloat = 0
            if tintColor.getWhite(&b, alpha: nil) {
                effectColor = UIColor.init(white: b, alpha: effectColorAlpha)
            }
        } else {
            var r : CGFloat = 0,g : CGFloat = 0,b : CGFloat = 0
            if tintColor.getRed(&r, green: &g, blue: &b, alpha: nil) {
                effectColor = UIColor.init(red: r, green: g, blue: b, alpha: effectColorAlpha)
            }
        }
        return self.applyBlurWith(blurRadius: 10, tintColor: effectColor, saturationDeltaFactor: -1.0, maskImage: nil)
    }
}

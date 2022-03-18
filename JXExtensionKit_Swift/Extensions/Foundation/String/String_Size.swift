//
//  String_Size.swift
//  JXExtensionKit_Swift
//
//  Created by Barnett on 2020/10/16.
//  Copyright © 2020 Barnett. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    /// 计算一段字符串的size
    /// - Parameters:
    ///   - attributeDic: 字体属性字典
    ///   - maxSize: 最大尺寸
    /// - Returns: 字符串尺寸
    func contenSizeWith(attributeDic : Dictionary<NSAttributedString.Key,Any>,maxSize : CGSize) -> CGSize {
        let attributed = NSMutableAttributedString.init(string: self)
        if attributeDic.count != 0 {
            attributed.addAttributes(attributeDic, range: NSRange.init(location: 0, length: self.count))
        }
        let stringSize = attributed.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin,.usesFontLeading], context: nil).size
        let newSize = CGSize.init(width: ceil(stringSize.width), height: ceil(stringSize.height))
        return newSize
    }
    
    /// CoreText计算文本size
    /// - Parameters:
    ///   - width: 最大宽度
    ///   - font: 字体
    func coreTextAttributeTextSizeWith(width : Double,font : UIFont) -> CGSize {
        var fontName : String = font.fontName
        if fontName == ".SFUI-Regular" {
            fontName = "TimesNewRomanPSMT";
        }
        let cfFont = CTFontCreateWithName(fontName as CFString, font.pointSize, nil)
        var leading = font.lineHeight - font.ascender + font.descender
        var paragraphSettings : CTParagraphStyleSetting = withUnsafeMutableBytes(of: &leading) { (leadingPoints)  in
            CTParagraphStyleSetting.init(spec: .lineBreakMode, valueSize: 8, value: leadingPoints.baseAddress!)
        }

        let paragraphStyle = CTParagraphStyleCreate(&paragraphSettings, 1)
        let textRange = CFRangeMake(0, self.count)

        let string = CFAttributedStringCreateMutable(kCFAllocatorDefault, self.count)

        CFAttributedStringReplaceString(string, CFRangeMake(0, 0), self as CFString)

        CFAttributedStringSetAttribute(string, textRange, kCTFontAttributeName, cfFont)
        CFAttributedStringSetAttribute(string, textRange, kCTParagraphStyleAttributeName, paragraphStyle)

        let framesetter = CTFramesetterCreateWithAttributedString(string!)
        let size = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, CGSize.init(width: width, height: 1/0.0), nil)
        return size
    }
}

//
//  String_Attribute.swift
//  JXExtensionKit_Swift
//
//  Created by Barnett on 2020/10/13.
//  Copyright © 2020 Barnett. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    /// 一段字符串添加关键字属性
    /// - Parameters:
    ///   - keyWordArr: 关键字数组
    ///   - attributedDic: 属性字典
    func addAttributedWithKeyWordArr(_ keyWordArr : Array<String>?,attributedDic : Dictionary<NSAttributedString.Key,Any>?) -> NSMutableAttributedString? {
        if keyWordArr == nil || keyWordArr == nil || keyWordArr!.isEmpty {
            return NSMutableAttributedString.init(string: self)
        }
        let attributeString = NSMutableAttributedString.init(string: self)
        for item in keyWordArr! {
            guard let regex = try? NSRegularExpression.init(pattern: item, options: .caseInsensitive) else {
                return NSMutableAttributedString.init(string: self)
            }
            regex.enumerateMatches(in: self, options: .reportCompletion, range: NSRange.init(location: 0, length: self.count)) { (result, flags, stop) in
                if result != nil {
                    attributeString.setAttributes(attributedDic, range: result!.range)
                }
            }
        }
        return attributeString
    }
}

extension Dictionary {
    
    /// 添加可变属性字体UIFont
    mutating func addTextFont(_ font : UIFont?) {
        if font == nil {
            return
        }
        self.updateValue(font as! Value, forKey: NSAttributedString.Key.font as! Key)
    }
    
    /// paragraphType 绘图的风格（居中，换行模式，行间距等诸多风格）NSParagraphStyle
    mutating func addParagraphType(_ paragraphType : NSParagraphStyle?) {
        if paragraphType == nil {
            return
        }
        self.updateValue(paragraphType as! Value, forKey: NSAttributedString.Key.paragraphStyle as! Key)
    }
    
    /// 文字颜色UIColor
    mutating func addTextColor(_ textColor : UIColor?) {
        if textColor == nil {
            return
        }
        self.updateValue(textColor as! Value, forKey: NSAttributedString.Key.foregroundColor as! Key)
    }
    
    /// 背景色UIColor
    mutating func addBackgroundColor(_ backgroundColor : UIColor?) {
        if backgroundColor == nil {
            return
        }
        self.updateValue(backgroundColor as! Value, forKey: NSAttributedString.Key.backgroundColor as! Key)
    }
    
    /// 取值为NSNumber 对象(整数). 0 表示没有连体字符, 1 表示使用默认的连体字符. 一般中文用不到，在英文中可能出现相邻字母连笔的情况。
    mutating func addLigature(_ isLigature : Bool?) {
        if isLigature == nil {
            return
        }
        let number : Int = isLigature! ? 1 : 0;
        self.updateValue(NSNumber.init(value: number) as! Value, forKey: NSAttributedString.Key.ligature as! Key)
    }
    
    /// 添加字符间距
    mutating func addKernValue(_ kernValue : Float?) {
        if kernValue == nil || kernValue! < 0 {
            return
        }
        self.updateValue(NSNumber.init(value: kernValue!) as! Value, forKey: NSAttributedString.Key.kern as! Key)
    }
    
    /// 添加删除线
    /// - Parameters:
    ///   - lineWidth: 线宽度
    ///   - lineColor: 线颜色
    mutating func addStrikethrough(lineWidth : Float?,lineColor : UIColor?) {
        if lineWidth != nil {
            self.updateValue(NSNumber.init(value: lineWidth!) as! Value, forKey: NSAttributedString.Key.strikethroughStyle as! Key)
        }
        if lineColor != nil {
            self.updateValue(lineColor as! Value, forKey: NSAttributedString.Key.strikethroughColor as! Key)
        }
    }
    
    /// 添加下划线
    /// - Parameters:
    ///   - lineWidth: 线宽度
    ///   - lineColor: 线颜色
    mutating func addUnderLine(lineWidth : Float?,lineColor : UIColor?) {
        if lineWidth != nil {
            self.updateValue(NSNumber.init(value: lineWidth!) as! Value, forKey: NSAttributedString.Key.underlineStyle as! Key)
        }
        if lineColor != nil {
            self.updateValue(lineColor as! Value, forKey: NSAttributedString.Key.underlineColor as! Key)
        }
    }
    
    /// 描绘边颜色
    mutating func addStrokeColor(_ color : UIColor?) {
        if color == nil {
            return
        }
        self.updateValue(color as! Value, forKey: NSAttributedString.Key.strokeColor as! Key)
    }
    
    /// 描边宽度
    mutating func addStrokeWidth(_ lineWidth : Float?) {
        if lineWidth == nil {
            return
        }
        self.updateValue(NSNumber.init(value: lineWidth!) as! Value, forKey: NSAttributedString.Key.strokeWidth as! Key)
    }
    
    /// 阴影
    mutating func addShadow(shadowOffset : CGSize?,shadowBlurRadius : CGFloat?,shadowColor : UIColor?) {
        let shadow = NSShadow.init()
        if shadowOffset != nil {
            shadow.shadowOffset = shadowOffset!
        }
        if shadowBlurRadius != nil {
            shadow.shadowBlurRadius = shadowBlurRadius!
        }
        if shadowColor != nil {
            shadow.shadowColor = shadowColor!
        }
        self.updateValue(shadow as! Value, forKey: NSAttributedString.Key.shadow as! Key)
    }
    
    /// 文字效果，取值为 NSString 对象，目前只有图版印刷效果可用，NSTextEffectLetterpressStyle
    mutating func addTextEffect(_ errect : String?) {
        if errect == nil {
            return
        }
        self.updateValue(errect as! Value, forKey: NSAttributedString.Key.textEffect as! Key)
    }
    
    /// 附属,例如图片
    mutating func addAttachment(_ content : NSTextAttachment?) {
        if content == nil {
            return
        }
        self.updateValue(content as! Value, forKey: NSAttributedString.Key.attachment as! Key)
    }
    
    /// 链接
    mutating func addLink(_ line : String?) {
        if line == nil {
            return
        }
        self.updateValue(URL.init(string: line!) as! Value, forKey: NSAttributedString.Key.link as! Key)
    }
    
    /// 基线偏移值，取值为 NSNumber （float）,正值上偏，负值下偏, 默认值是0
    mutating func addLineOffset(_ offset : Float?) {
        if offset == nil {
            return
        }
        self.updateValue(NSNumber.init(value: offset!) as! Value, forKey: NSAttributedString.Key.baselineOffset as! Key)
    }
    
    /// 设置字形倾斜度，取值为 NSNumber （float）,正值右倾，负值左倾, 默认值是0(表示没有倾斜)
    mutating func addObliqueness(_ number : Float?) {
        if number == nil {
            return
        }
        self.updateValue(NSNumber.init(value: number!) as! Value, forKey: NSAttributedString.Key.obliqueness as! Key)
    }
    
    /// 设置文本横向拉伸属性，取值为 NSNumber （float）,正值横向拉伸文本，负值横向压缩文本
    mutating func addExpansion(_ number : Float?) {
        if number == nil {
            return
        }
        self.updateValue(NSNumber.init(value: number!) as! Value, forKey: NSAttributedString.Key.expansion as! Key)
    }
    
    /// 设置文字排版方向，取值为 NSNumber 对象(整数)，0 表示横排文本，1 表示竖排文本 在iOS中, 总是以横向排版
    mutating func addComposing(_ number : Int?) {
        if number == nil || number != 0 || number != 1 {
            return
        }
        
        self.updateValue(NSNumber.init(value: number!) as! Value, forKey: NSAttributedString.Key.verticalGlyphForm as! Key)
    }
    
}

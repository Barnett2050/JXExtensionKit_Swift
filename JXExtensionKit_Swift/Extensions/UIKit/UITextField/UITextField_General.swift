//
//  UITextField_General.swift
//  JXExtensionKit_Swift
//
//  Created by Barnett on 2020/7/10.
//  Copyright © 2020 Barnett. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    /// 当前输入是否高亮
    func inputHighlight() -> Bool {
        let selectedRange:UITextRange? = self.markedTextRange
        let position = self.position(within: selectedRange!, atCharacterOffset: 0)
        let flag = position != nil
        return flag
    }
    
    /// 选中所有文本
    func selectAllText() {
        let range = self.textRange(from: self.beginningOfDocument, to: self.endOfDocument)
        self.selectedTextRange = range
    }
    
    /// 设定选中文本
    /// - Parameter range: 范围
    func selectTextRange(range : NSRange) {
        let beginning = self.beginningOfDocument
        let startPosition = self.position(from: beginning, offset: range.location)
        let endPosition = self.position(from: beginning, offset: NSMaxRange(range))
        let selectionRange = self.textRange(from: startPosition ?? UITextPosition.init(), to: endPosition ?? UITextPosition.init())
        self.selectedTextRange = selectionRange
    }
}

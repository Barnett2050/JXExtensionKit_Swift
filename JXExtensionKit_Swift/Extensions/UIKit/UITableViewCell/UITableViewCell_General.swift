//
//  UITableViewCell_General.swift
//  JXExtensionKit_Swift
//
//  Created by Barnett on 2020/7/10.
//  Copyright © 2020 Barnett. All rights reserved.
//

import Foundation
import UIKit

extension UITableViewCell
{
    /// 设置分割线左右边距
    /// - Parameters:
    ///   - leftSpace: 左边距
    ///   - rightSpace: 右边距
    func cellBottomLineSpace(_ leftSpace:CGFloat,_ rightSpace:CGFloat) {
        self.layoutMargins = UIEdgeInsets.init(top: 0, left: leftSpace, bottom: 0, right: rightSpace)
        self.separatorInset = UIEdgeInsets.init(top: 0, left: leftSpace, bottom: 0, right: rightSpace)
    }
    
    /// 设置分割线左边距
    func cellBottomLineLeftSpace(_ leftSpace:CGFloat) {
        self.cellBottomLineSpace(leftSpace, 0)
    }
    
    /// 设置左右边距为0
    func cellBottomLineZeroSpace() {
        self.cellBottomLineSpace(0, 0)
    }
    
    /// 隐藏分割线
    func hiddenCellBottomLine() {
        self.layoutMargins = UIEdgeInsets.init(top: 0, left: UIScreen.main.bounds.size.width, bottom: 0, right: 0)
        self.separatorInset = UIEdgeInsets.init(top: 0, left: UIScreen.main.bounds.size.width, bottom: 0, right: 0)
    }
}

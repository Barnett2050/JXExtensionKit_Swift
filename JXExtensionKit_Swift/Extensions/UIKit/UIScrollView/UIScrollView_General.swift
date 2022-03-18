//
//  UIScrollView_General.swift
//  JXExtensionKit_Swift
//
//  Created by Barnett on 2020/6/15.
//  Copyright © 2020 Barnett. All rights reserved.
//

import Foundation
import UIKit

extension UIScrollView {
    
    /// 滚动到顶部
    /// - Parameter animated: 动画
    func scrollToTop(animated : Bool) {
        var point = self.contentOffset
        point.y = 0 - self.contentInset.top
        self.setContentOffset(point, animated: animated)
    }
    /// 滚动到底部
    /// - Parameter animated: 动画
    func scrollToBottom(animated : Bool) {
        var point = self.contentOffset
        point.y = self.contentSize.height - self.bounds.size.height + self.contentInset.bottom
        self.setContentOffset(point, animated: animated)
    }
    /// 滚动到左边
    /// - Parameter animated: 动画
    func scrollToLeft(animated : Bool) {
        var point = self.contentOffset
        point.x = 0 - self.contentInset.left
        self.setContentOffset(point, animated: animated)
    }
    /// 滚动到右边
    /// - Parameter animated: 动画
    func scrollToRight(animated : Bool) {
        var point = self.contentOffset
        point.x = self.contentSize.width - self.bounds.size.width + self.contentInset.right
        self.setContentOffset(point, animated: animated)
    }
    
}

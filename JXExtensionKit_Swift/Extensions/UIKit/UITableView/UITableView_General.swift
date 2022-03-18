//
//  UITableView_General.swift
//  JXExtensionKit_Swift
//
//  Created by Barnett on 2020/6/15.
//  Copyright © 2020 Barnett. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    
    /// tableView更新block，例如insert, delete, 或者 select
    /// - Parameter block: 操作回调
    func updateWithBlock(block : (UITableView) -> Void) {
        self.beginUpdates()
        block(self)
        self.endUpdates()
    }
    
    /// 取消tableView所有行的选中
    /// - Parameter animated: 动画效果
    func clearSelectedRows(animated : Bool) {
        let indexs = self.indexPathsForVisibleRows ?? []
        if indexs.isEmpty {
            return
        }
        for index in indexs {
            self.deselectRow(at: index, animated: animated)
        }
    }
    
    
}

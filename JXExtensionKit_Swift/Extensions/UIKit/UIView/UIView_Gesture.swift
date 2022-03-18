//
//  UIView_Gesture.swift
//  JXExtensionKit_Swift
//
//  Created by Barnett on 2020/6/19.
//  Copyright © 2020 Barnett. All rights reserved.
//

import Foundation
import UIKit

extension UIView
{
    /// 添加Tap手势
    func addTapGestureRecognizer(target:AnyObject,action:Selector) {
        let tapGesture = UITapGestureRecognizer.init(target: target, action: action)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGesture)
    }
    
    /// 添加Pan手势
    func addPanGestureRecognizer(target:AnyObject,action:Selector) {
        let panGesture = UIPanGestureRecognizer.init(target: target, action: action)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(panGesture)
    }
    
    /// 添加LongPress手势
    func addLongPressGestureRecognizer(target:AnyObject,action:Selector) {
        let longPressGesture = UILongPressGestureRecognizer.init(target: target, action: action)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(longPressGesture)
    }
}

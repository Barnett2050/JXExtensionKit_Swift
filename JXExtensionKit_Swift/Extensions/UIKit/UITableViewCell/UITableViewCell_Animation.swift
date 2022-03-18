//
//  UITableViewCell_Animation.swift
//  JXExtensionKit_Swift
//
//  Created by Barnett on 2020/7/10.
//  Copyright © 2020 Barnett. All rights reserved.
//

import Foundation
import UIKit

extension UITableViewCell {
    
    /// 显示缩放效果
    func showScaleAnimation() {
        let transform = CATransform3DMakeScale(0.68, 0.68, 1.0)
        self.layer.transform = transform
        self.layer.opacity = 0
        UIView.beginAnimations("scale", context: nil)
        UIView.setAnimationDuration(0.5)
        self.layer.transform = CATransform3DIdentity
        self.layer.opacity = 1
        UIView.commitAnimations()
    }
    
    /// 显示缩进效果
    func showIndentAnimation() {
        let originalRect = self.frame
        var newRect = self.frame
        newRect.origin.x = UIScreen.main.bounds.size.width
        self.frame = newRect
        UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.frame = originalRect
        }, completion: nil)
    }
    
    /// 显示旋转效果
    func showRoatationAnimation() {
        var rotation = CATransform3DMakeRotation(CGFloat.pi/6, 0.0, 0.5, 0.4)
        rotation.m34 = 1.0/(-600)
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize.init(width: 10, height: 10)
        self.alpha = 0;
        self.layer.transform = rotation
        
        UIView.beginAnimations("rotation", context: nil)
        UIView.setAnimationDuration(0.5)
        self.layer.transform = CATransform3DIdentity
        self.alpha = 1
        self.layer.shadowOffset = CGSize.init(width: 0, height: 0)
        UIView.commitAnimations()
    }
}

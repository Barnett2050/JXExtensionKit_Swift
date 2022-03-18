//
//  UIView_General.swift
//  JXExtensionKit_Swift
//
//  Created by Barnett on 2020/6/19.
//  Copyright © 2020 Barnett. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    /// 屏幕快照
    func snapshot() -> UIImage? {
        /*
        renderInContext:方式实际上是通过遍历UIView的layer tree进行渲染，但是它不支持动画的渲染，它的的性能会和layer tree的复杂度直接关联
        drawViewHierarchyInRect:afterScreenUpdates:的api是苹果基于UIView的扩展，与第一种方式不同，这种方式是直接获取当前屏幕的“快照”，此种方式的性能与UIView的frame大小直接关联。
        在UIView内容不是很“长”的情况下，第二种方式有内存优势的；但是随着UIView的内容增加，第二种方式会有较大增加；
                 第一种(内存)           第二种(内存)       第一种(耗时)        第二种(耗时)
        1~2屏    28.4323M             8.1431M           195.765972ms      271.728992ms
        2~3屏    36.0012M             8.5782M           221.408010ms      280.839980ms
        5屏以上   38.511718M           23.1875M          448.800981ms      565.396011ms
        */
        if self.isKind(of: UIScrollView.classForCoder()) {
            let scrollview = self as! UIScrollView
            var rect = self.frame
            rect.size = scrollview.contentSize
            UIGraphicsBeginImageContext(rect.size)
            let context = UIGraphicsGetCurrentContext()
            scrollview.layer.render(in: context!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return image
        } else {
            /*
            * 参数一: 指定将来创建出来的bitmap的大小
            * 参数二: 设置透明YES代表透明，NO代表不透明
            * 参数三: 代表缩放,0代表不缩放
            */
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, UIScreen.main.scale)
            self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return image
        }
    }
    
    /// 截取 view 上某个位置的图像
    /// - Parameter rect: 位置
    /// - Returns: 图像
    func cutoutInViewWith(rect : CGRect) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, self.isOpaque, 0.0)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.layer.contents = nil
        
        let cgImageCorpped = image?.cgImage?.cropping(to: rect)
        let imageCorpped = UIImage(cgImage: cgImageCorpped!)
        return imageCorpped
    }
    
    /// 毛玻璃效果
    /// - Parameter blurStyle: 模糊程度
    func addBlurEffect(blurStyle : UIBlurEffect.Style) {
        let effect = UIBlurEffect.init(style: blurStyle)
        let effectView = UIVisualEffectView.init(effect: effect)
        effectView.frame = self.bounds
        self.addSubview(effectView)
    }
}

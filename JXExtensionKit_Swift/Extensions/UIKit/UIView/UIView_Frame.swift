//
//  UIView_Frame.swift
//  JXExtensionKit_Swift
//
//  Created by Barnett on 2020/6/19.
//  Copyright © 2020 Barnett. All rights reserved.
//

import Foundation
import UIKit

extension UIView
{
    /// 视图X坐标
    var jx_x : CGFloat
    {
        set{
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame;
        }
        get{
            return self.frame.origin.x
        }
    }
    /// 视图Y坐标
    var jx_y : CGFloat
    {
        set{
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame;
        }
        get{
            return self.frame.origin.y
        }
    }
    /// 视图最大X坐标
    var jx_maxX : CGFloat
    {
        return (self.frame.origin.x + self.frame.size.width)
    }
    /// 视图最大Y坐标
    var jx_maxY : CGFloat
    {
        return (self.frame.origin.y + self.frame.size.height)
    }
    /// 视图中心X坐标
    var jx_centerX : CGFloat
    {
        set{
            var center = self.center
            center.x = newValue
            self.center = center
        }
        get{
            return self.center.x
        }
    }
    /// 视图中心Y坐标
    var jx_centerY : CGFloat
    {
        set{
            var center = self.center
            center.y = newValue
            self.center = center
        }
        get{
            return self.center.y
        }
    }
    /// 视图宽度
    var jx_width : CGFloat
    {
        set{
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame;
        }
        get{
            return self.frame.size.width
        }
    }
    /// 视图高度
    var jx_height : CGFloat
    {
        set{
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame;
        }
        get{
            return self.frame.size.height
        }
    }
    /// 视图size
    var jx_size : CGSize
    {
        set{
            var frame = self.frame
            frame.size = newValue
            self.frame = frame;
        }
        get{
            return self.frame.size
        }
    }
    /// 视图origin
    var jx_origin : CGPoint
    {
        set{
            var frame = self.frame
            frame.origin = newValue
            self.frame = frame;
        }
        get{
            return self.frame.origin
        }
    }
    
    /// 视图在父视图水平居中，只适用于frame布局
    func alignHorizontal() -> Void {
        self.jx_x = ((self.superview?.jx_width ?? self.jx_width) - self.jx_width) * 0.5
    }
    
    /// 视图在父视图垂直居中，只适用于frame布局
    func alignVertical() -> Void {
        self.jx_y = ((self.superview?.jx_height ?? self.jx_height) - self.jx_height) * 0.5
    }
    
}

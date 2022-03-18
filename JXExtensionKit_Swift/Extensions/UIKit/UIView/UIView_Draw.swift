//
//  UIView_Draw.swift
//  JXExtensionKit_Swift
//
//  Created by Barnett on 2020/6/19.
//  Copyright © 2020 Barnett. All rights reserved.
//

import Foundation
import UIKit

/**
使用CAShapeLayer和UIBezierPath设置圆角，对内存的消耗最少，而且渲染快速
注意：view的frame必须已知，自动布局调入另一个传入frame方法
*/

extension UIView
{
    /// 添加圆角，适用于自动布局，传入设置frame
    /// - Parameters:
    ///   - viewBounds: 目标view的frame
    ///   - rectCorner: 圆角位置
    ///   - radius: 圆角大小
    func addRectCorner(viewBounds:CGRect,rectCorner:UIRectCorner,radius:CGFloat) {
        let path = UIBezierPath.init(roundedRect: viewBounds, byRoundingCorners: rectCorner, cornerRadii: CGSize.init(width: radius, height: radius))
        let maskLayer = CAShapeLayer.init()
        maskLayer.frame = self.bounds
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
    /// 添加圆角,适用于已知frame，即非自动布局
    /// - Parameters:
    ///   - rectCorner: 圆角位置
    ///   - radius: 圆角大小
    func addRectCorner(rectCorner:UIRectCorner,radius:CGFloat) {
        self.addRectCorner(viewBounds: self.bounds, rectCorner: rectCorner, radius: radius)
    }
    /// 添加全圆角，frame布局
    /// - Parameter radius: 圆角大小
    func addAllRectCorner(radius:CGFloat) {
        self.addRectCorner(rectCorner: UIRectCorner.allCorners, radius: radius)
    }
    /// 添加全圆角，自动布局传入viewBounds
    /// - Parameter radius: 圆角大小
    func addAllRectCorner(viewBounds:CGRect,radius:CGFloat) {
        self.addRectCorner(viewBounds: viewBounds, rectCorner: UIRectCorner.allCorners, radius: radius)
    }
    
    /// 绘制虚线
    /// - Parameters:
    ///   - pointArr: 坐标数组
    ///   - lineWidth: 虚线的宽度
    ///   - lineLength: 虚线的长度
    ///   - lineSpace: 虚线的间距
    ///   - lineColor: 虚线的颜色
    func drawDashLine(pointArr:Array<CGPoint>,lineWidth:CGFloat,lineLength:CGFloat,lineSpace:CGFloat,lineColor:UIColor) {
        
        let shapeLayer = CAShapeLayer.init()
        shapeLayer.bounds = self.bounds
        shapeLayer.position = CGPoint.init(x: self.frame.size.width/2, y: self.frame.size.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = lineColor.cgColor
        // 设置虚线宽度
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        // 设置线宽，线间距
        let lineLengthNum = NSNumber.init(value: Int(lineLength))
        let lineSpaceNum = NSNumber.init(value: Int(lineSpace))
        
        shapeLayer.lineDashPattern = [lineLengthNum,lineSpaceNum]
        
        let path = CGMutablePath.init()
        let point = pointArr[0]
        path.move(to: point)
        for (index,value) in pointArr.enumerated() {
            if index > 0 {
                path.addLine(to: value)
            }
        }
        shapeLayer.path = path
        
        self.layer.addSublayer(shapeLayer)
    }
}

//
//  UIButton_Show.swift
//  JXExtensionKit_Swift
//
//  Created by Barnett on 2020/9/2.
//  Copyright © 2020 Barnett. All rights reserved.
//

import Foundation
import UIKit

enum ImageTitlePositionType : Int {
    case ImageTitlePositionTypeNone = 0  //默认无效果
    case ImageLeftTitleRightPositionType //图片在左，文字在右
    case ImageRightTitleLeftPositionType //图片在右，文字在左
    case ImageTopTitleBottomPositionType //图片在上，文字在下
    case ImageBottomTitleTopPositionType //图片在下，文字在上
}

extension UIButton {
    private struct AssociatedKey {
        static var loadIndicatorView: String = "loadIndicatorView"
        static var btnTitle: String = "btnTitle"
    }
    // 菊花view
    var loadIndicatorView : UIActivityIndicatorView {
        set {
            objc_setAssociatedObject(self, &AssociatedKey.loadIndicatorView, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.loadIndicatorView) as? UIActivityIndicatorView ?? UIActivityIndicatorView.init()
        }
    }
    // 按钮名称
    var btnTitle : String {
        set {
            objc_setAssociatedObject(self, &AssociatedKey.btnTitle, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.btnTitle) as? String ?? ""
        }
    }
    
    
    /// 设置自定义图片文字位置按钮
    /// - Parameters:
    ///   - position: 位置
    ///   - spacing: 图片和文字间隙
    func setImagePosition(_ position : ImageTitlePositionType,spacing : CGFloat) {
        self.setImage(self.currentImage, for: .normal)
        self.setTitle(self.currentTitle, for: .normal)
        
        var imageWidth : CGFloat = 0
        var imageHeight : CGFloat = 0
        var labelWidth : CGFloat = 0
        var labelHeight : CGFloat = 0
        if self.imageView?.image != nil {
            imageWidth = self.imageView!.image!.size.width
            imageHeight = self.imageView!.image!.size.height
        }
        if self.titleLabel?.text != nil {
            let size = NSString(string: self.titleLabel!.text!).size(withAttributes: [NSAttributedString.Key.font : self.titleLabel!.font ?? UIFont.systemFont(ofSize: 18)])
            labelWidth = size.width
            labelHeight = size.height
        }
        //image中心移动的x距离
        let imageOffsetX = (imageWidth + labelWidth) / 2 - imageWidth / 2
        //image中心移动的y距离
        let imageOffsetY = imageHeight / 2 + spacing / 2
        // label中心移动的x距离
        let labelOffsetX = (imageWidth + labelWidth / 2) - (imageWidth + labelWidth) / 2
        // label中心移动的y距离
        let labelOffsetY = labelHeight / 2 + spacing / 2
        
        let tempWidth = CGFloat.maximum(labelWidth, imageWidth)
        let changedWidth = labelWidth + imageWidth - tempWidth
        let tempHeight = CGFloat.maximum(labelHeight, imageHeight)
        let changedHeight = labelHeight + imageHeight + spacing - tempHeight
        
        switch position {
        case .ImageTitlePositionTypeNone:
            self.imageEdgeInsets = UIEdgeInsets.zero
            self.titleEdgeInsets = UIEdgeInsets.zero
            self.contentEdgeInsets = UIEdgeInsets.zero
            break
        case .ImageLeftTitleRightPositionType:
            self.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -spacing/2, bottom: 0, right: spacing/2)
            self.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: spacing/2, bottom: 0, right: -spacing/2)
            self.contentEdgeInsets = UIEdgeInsets.init(top: 0, left: spacing/2, bottom: 0, right: spacing/2)
            break
        case .ImageRightTitleLeftPositionType:
            self.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: labelWidth + spacing/2, bottom: 0, right: -(labelWidth + spacing/2))
            self.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -(imageWidth + spacing/2), bottom: 0, right: imageWidth + spacing/2)
            self.contentEdgeInsets = UIEdgeInsets.init(top: 0, left: spacing/2, bottom: 0, right: spacing/2)
            break
        case .ImageTopTitleBottomPositionType:
            self.imageEdgeInsets = UIEdgeInsets.init(top: -imageOffsetY, left: imageOffsetX, bottom: imageOffsetY, right: -imageOffsetX)
            self.titleEdgeInsets = UIEdgeInsets.init(top: labelOffsetY, left: -labelOffsetX, bottom: -labelOffsetY, right: labelOffsetX)
            self.contentEdgeInsets = UIEdgeInsets.init(top: imageOffsetY, left: -changedWidth/2, bottom: changedHeight-imageOffsetY, right: -changedWidth/2)
            break
        case .ImageBottomTitleTopPositionType:
            self.imageEdgeInsets = UIEdgeInsets.init(top: imageOffsetY, left: imageOffsetX, bottom: -imageOffsetY, right: -imageOffsetX)
            self.titleEdgeInsets = UIEdgeInsets.init(top: -labelOffsetY, left: -labelOffsetX, bottom: labelOffsetY, right: labelOffsetX)
            self.contentEdgeInsets = UIEdgeInsets.init(top: changedHeight-imageOffsetY, left: -changedWidth/2, bottom: imageOffsetY, right: -changedWidth/2)
            break
        }
        self.layoutIfNeeded()
    }
    
    /// 开始加载菊花动画
    /// - Parameters:
    ///   - transform: 菊花比例
    ///   - color: 菊花颜色
    ///   - isHideTitle: 是否隐藏标题
    func startAnimationWithTransform(transform : CGFloat,color : UIColor,isHideTitle : Bool) {
        self.isUserInteractionEnabled = false
        
        let loadIndicatorView = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.white)
        loadIndicatorView.transform = CGAffineTransform.init(scaleX: transform, y: transform)
        loadIndicatorView.color = color
        
        self.btnTitle = self.titleLabel!.text!
        if isHideTitle {
            self.setTitle(nil, for: .normal)
            loadIndicatorView.center = CGPoint.init(x: self.frame.size.width/2, y: self.frame.size.height/2)
        }
        self.addSubview(loadIndicatorView)
        loadIndicatorView.startAnimating()
        self.loadIndicatorView = loadIndicatorView
    }
    
    /// 停止动画
    /// - Parameter isShowTitle: 是否显示按钮名称
    func stopAnimationAndShowTitle(isShowTitle : Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
            self.isUserInteractionEnabled = false
        }
        if isShowTitle {
            self.setTitle(self.btnTitle, for: .normal)
        }
        self.loadIndicatorView.stopAnimating()
    }
}

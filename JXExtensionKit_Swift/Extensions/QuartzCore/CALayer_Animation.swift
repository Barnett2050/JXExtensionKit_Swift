//
//  CALayer_Animation.swift
//  JXExtensionKit_Swift
//
//  Created by Barnett on 2020/6/15.
//  Copyright © 2020 Barnett. All rights reserved.
//

import Foundation
import QuartzCore

extension CALayer {
    /// 摇动动画
    func shakeAnimation() -> Void {
        let kfa:CAKeyframeAnimation = CAKeyframeAnimation.init(keyPath: "transform.translation.x")
        let s:CGFloat = 5.0
        kfa.values = [(-s),(0),(s),(0),(-s),(0),(s),(0)]
        kfa.duration = 0.3
        kfa.repeatCount = 2
        kfa.isRemovedOnCompletion = true
        self.add(kfa, forKey: "shake")
    }
}

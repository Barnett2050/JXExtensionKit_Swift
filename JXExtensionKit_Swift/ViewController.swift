//
//  ViewController.swift
//  JXExtensionKit_Swift
//
//  Created by Barnett on 2020/6/15.
//  Copyright © 2020 Barnett. All rights reserved.
//

import UIKit

@objcMembers class ViewController: UIViewController {
    
    dynamic var titleString : String? = nil
    var count : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        self.addObserver(self, forKeyPath: "titleString", options: .new, context: nil)
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        print(keyPath)
    }
    
    @objc func buttonAction(_ sender : UIButton) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.titleString = "name"
    }
}


//
//  ViewController.swift
//  Example
//
//  Created by 王垒 on 2017/4/27.
//  Copyright © 2017年 王垒. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.backgroundColor = UIColor.yellow
        
        let textField = UITextField(frame: CGRect(x: 15, y: 120, width: JMTWindowWidth - 30, height: 35))
        textField.borderStyle = .roundedRect
        view.addSubview(textField)
        
        WLCardKeyBoard.defaule.addKeyBoard(view, field: textField)
        
        textField.becomeFirstResponder()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


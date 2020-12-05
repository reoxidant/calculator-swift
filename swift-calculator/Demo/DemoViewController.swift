//
//  DemoViewController.swift
//  swift-calculator
//
//  Created by Виталий Шаповалов on 05.12.2020.
//  Copyright © 2020 Виталий Шаповалов. All rights reserved.
//

import UIKit

class DemoViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    
    @IBAction func appendDigitToStack(_ sender: UIButton) {
        let digit = sender.currentTitle
        print("digit is \(digit!)")
    }
    
}

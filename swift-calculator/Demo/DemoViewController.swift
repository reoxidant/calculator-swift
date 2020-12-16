//
//  DemoViewController.swift
//  swift-calculator
//
//  Created by Виталий Шаповалов on 05.12.2020.
//  Copyright © 2020 Виталий Шаповалов. All rights reserved.
//

import UIKit

class DemoViewController: UIViewController {
    
    var userIsTheMiddleOfTypingANumber: Bool = false
    
    @IBOutlet weak var display: UILabel!
    
    @IBAction func enter() {
        userIsTheMiddleOfTypingANumber = false
    }
    
    var operandStack: Array <Double>()
    
    @IBAction func appendDigitToStack(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        }else{
            display.text = digit
            userIsTheMiddleOfTypingANumber = true
        }
    }
    
}

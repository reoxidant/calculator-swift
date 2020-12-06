//
//  ViewController.swift
//  swift-calculator
//
//  Created by Виталий Шаповалов on 01.12.2020.
//  Copyright © 2020 Виталий Шаповалов. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    @IBOutlet weak var display: UILabel!
    
    var typeInTheMiddleOfNumber:Bool = false
    
    @IBAction func digitsPressed(_ sender: UIButton) {
        let digit = sender.currentTitle!
        
        if(typeInTheMiddleOfNumber){
            display.text?.append(digit)
        }else{
            display.text = digit
            typeInTheMiddleOfNumber = true
        }
    }
}


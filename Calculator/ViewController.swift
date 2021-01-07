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
    
    var operateStack = Array<Double>()
    
    var displayValue: Double{
        get{
            return (display.text! as NSString).doubleValue
        }
        set{
            display.text = "\(newValue)"
        }
    }
    
    @IBAction func digitsPressed(_ sender: UIButton) {
        let digit = sender.currentTitle!
        
        if(typeInTheMiddleOfNumber){
            display.text?.append(digit)
        }else{
            display.text = digit
            typeInTheMiddleOfNumber = true
        }
    }
    
    @IBAction func enter() {
        typeInTheMiddleOfNumber = false
        operateStack.append(displayValue)
        print("operateStack - \(operateStack)")
    }
    
    @IBAction func operate(_ sender: UIButton) {
        let operation = sender.currentTitle!
        
        if(typeInTheMiddleOfNumber){enter()}
        
        switch operation{
            case "÷": performOperation {$1 / $0}
            case "×": performOperation {$0 * $1}
            case "-": performOperation {$1 - $0}
            case "+": performOperation {$0 + $1}
            default: break;
        }
        print(operation)
    }
    
    func performOperation(operation:(Double, Double) -> Double){
        if operateStack.count >= 2{
            displayValue = operation(operateStack.removeLast(), operateStack.removeLast())
            enter()
        }
    }
}

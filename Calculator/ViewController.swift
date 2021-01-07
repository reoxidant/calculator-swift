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
        let hasDot = display.text!.contains(".") ? true : false
        let pressedDot = sender.currentTitle!.contains(".") ? true : false
        
        let digit = sender.currentTitle!
        
        if(typeInTheMiddleOfNumber){
            if !hasDot {
                display.text = display.text! + digit
            }else if !pressedDot{
                display.text = display.text! + digit
            }
        }else{
            if !pressedDot {
                display.text = digit
            } else if !hasDot {
                display.text = display.text! + digit
            }
            typeInTheMiddleOfNumber = true
        }
    }
    
    @IBAction func enter() {
        typeInTheMiddleOfNumber = false
        operateStack.append(displayValue)
    }
    
    @IBAction func operate(_ sender: UIButton) {
        let operation = sender.currentTitle!
        
        if(typeInTheMiddleOfNumber){enter()}
        
        switch operation{
        case "÷": performOperation {$1 / $0}
        case "×": performOperation {$0 * $1}
        case "-": performOperation {$1 - $0}
        case "+": performOperation {$0 + $1}
        case "sin": performOperation {sin($0 * Double.pi / 180)}
        case "cos": performOperation {cos($0 * Double.pi / 180)}
        case "√": performOperation {sqrt($0)}
        case "𝜋": performOperation {$0 * Double.pi}
        default: break;
        }
    }
    
    func performOperation(operation:(Double, Double) -> Double){
        if operateStack.count >= 2{
            displayValue = operation(operateStack.removeLast(), operateStack.removeLast())
            enter()
        }
    }
    
    func performOperation(operation: (Double) -> Double){
        if operateStack.count >= 1{
            displayValue = operation(operateStack.removeLast())
            enter()
        }
    }
}

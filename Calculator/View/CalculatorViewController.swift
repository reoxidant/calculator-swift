//
//  ViewController.swift
//  swift-calculator
//
//  Created by Виталий Шаповалов on 01.12.2020.
//  Copyright © 2020 Виталий Шаповалов. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    
    var typeInTheMiddleOfNumber:Bool = false
    
    var displayValue: Double{
        get{
            return (display.text! as NSString).doubleValue
        }
        set{
            addToHistory(value: "=")
            display.text = "\(newValue)"
        }
    }
    
    @IBOutlet weak var displayHistory: UILabel!
    
    var hasOperation: Bool = false
    
    let brain = CalculatorBrain()
    
    @IBAction func digitsPressed(_ sender: UIButton) {
        let digit = sender.currentTitle!
        let hasDot = digit.contains(".") && display.text!.contains(".")
        
        if(typeInTheMiddleOfNumber){
            display.text = display.text! + (hasDot ? "" : digit)
        }else{
            display.text = (digit.contains(".") ? "0" + digit : digit)
        }
        typeInTheMiddleOfNumber = true
    }
    
    @IBAction func enter() {
        if typeInTheMiddleOfNumber {
            addToHistory(value: "\(displayValue)")
        }
        if !hasOperation && typeInTheMiddleOfNumber {
            addToHistory(value: "⏎")
        }
        
        typeInTheMiddleOfNumber = false
        hasOperation = false
       
        if let result = brain.pushOperand(operand:displayValue){
            displayValue = result
        } else {
            displayValue = 0
        }
    }
    
    @IBAction func operate(_ sender: UIButton) {
        hasOperation = true
        if typeInTheMiddleOfNumber {enter()}
        if let operation = sender.currentTitle {
            addToHistory(value: operation)
            if (operation == "𝜋" || operation == "cos"){
                enter()
            }
            if let result = brain.performOperation(symbol:operation){
                displayValue = result
            } else {
                displayValue = 0
            }
        }
    }
    
    func addToHistory (value:String)
    {
        if let i = displayHistory.text!.firstIndex(of: "=") {
            displayHistory.text!.remove(at: i)
            displayHistory.text!.removeLast()
        }
        
        displayHistory.text! += "\(value) "
    }
        
    @IBAction func resetState() {
        display.text! = "0"
        brain.removeStack()
        typeInTheMiddleOfNumber = false
        displayHistory.text! = ""
    }
}

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
    
    var displayValue: Double?{
        get{
            let formatter = NumberFormatter()
            if let convertedValue = formatter.number(from: display.text!) as? Double{
                return convertedValue
            } else {
                return 0
            }
        }
        set{
            display.text = "\(newValue ?? 0)"
        }
    }
    
    @IBAction func pressedBackspace(_ sender: UIButton) {
        if display.text!.count > 1{
            display.text = String(display.text!.dropLast())
            typeInTheMiddleOfNumber = true
        } else {
            display.text = "\(0.0)"
            typeInTheMiddleOfNumber = false
        }
    }
    
    @IBAction func signPlusMinusPressed() {
        if typeInTheMiddleOfNumber {
            displayValue = brain.convertNegOrPosValue(value: displayValue)
        } else {
            if let result = brain.performOperation(symbol:"+/-"){
                displayValue = result
            }
        }
    }
    
    @IBOutlet weak var displayHistory: UILabel!
    
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
        typeInTheMiddleOfNumber = false
        if let result = brain.pushOperand(operand:displayValue!){
            addToHistory(value: brain.description + " ⏎")
            displayValue = result
        } else {
            displayValue = 0
        }
    }
    
    @IBAction func operate(_ sender: UIButton) {
        if typeInTheMiddleOfNumber {enter()}
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(symbol:operation){
                displayValue = result
            } else {
                displayValue = 0
            }
            addToHistory(value: brain.description + " =")
        }
    }
    
    func addToHistory (value:String)
    {
        displayHistory.text! = "\(value)"
    }
    
    @IBAction func resetState() {
        display.text! = "0"
        brain.removeStack()
        typeInTheMiddleOfNumber = false
        displayHistory.text! = " "
    }
}

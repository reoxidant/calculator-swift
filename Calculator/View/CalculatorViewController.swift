//
//  ViewController.swift
//  swift-calculator
//
//  Created by Виталий Шаповалов on 01.12.2020.
//  Copyright © 2020 Виталий Шаповалов. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    @IBOutlet weak var resetOperation: UIButton!
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var displayHistory: UILabel!
    
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
    
    var displayResult:String{
        get{
            return ""
        }
        set{
            addToHistory(value: "\(newValue)")
        }
    }
    
    let brain = CalculatorBrain()
    
    @IBAction func undoAndBackspaceOperation() {
        if typeInTheMiddleOfNumber {
            if display.text!.count > 1{
                display.text = String(display.text!.dropLast())
            } else {
                display.text = "\(0.0)"
                typeInTheMiddleOfNumber = false
            }
        } else {
            displayValue = checkBrainOnErrors(eval:brain.returnLastOperation())
            if brain.description != ""{
                addToHistory(value: brain.description + " =")
            } else {
                addToHistory(value: " ")
            }
        }
    }
    
    @IBAction func saveInMemory() {
        typeInTheMiddleOfNumber = false
        if let value = checkBrainOnErrors(eval:brain.setVariableValue(symbol: "M", value: displayValue!)){
            displayValue = value
        }
        
    }
    
    @IBAction func pushFromMemory() {
        if typeInTheMiddleOfNumber{enter()}
        if let value = checkBrainOnErrors(eval:brain.pushOperand(variable: "M")){
            displayValue = value
        } else {
            displayValue = 0
        }
    }
    
    @IBAction func resetState(_ sender: UIButton) {
        if sender.currentTitle == "C"{
            sender.setTitle("AC", for: .normal)
        } else {
            brain.removeVariables()
        }
        typeInTheMiddleOfNumber = false
        displayValue = 0
        displayHistory.text! = " "
        brain.removeStack()
    }
    
    @IBAction func signPlusMinusPressed() {
        if typeInTheMiddleOfNumber {
            displayValue = brain.convertNegOrPosValue(value: displayValue)
        } else {
            if let result = checkBrainOnErrors(eval:brain.performOperation(symbol:"+/-")){
                displayValue = result
            }
        }
    }
    
    @IBAction func operate(_ sender: UIButton) {
        if typeInTheMiddleOfNumber {enter()}
        if let operation = sender.currentTitle {
            let(res, errorName) = brain.performOperation(symbol:operation)
            if let error = errorName{
                displayResult = error
            } else {
                if let result = res{
                    displayValue = result
                } else {
                    displayValue = 0
                }
                addToHistory(value: brain.description + " =")
            }
        }
    }
    
    @IBAction func digitsPressed(_ sender: UIButton) {
        resetOperation.setTitle("C", for: .normal)
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
        if let result = checkBrainOnErrors(eval:brain.pushOperand(operand:displayValue!)){
            addToHistory(value: brain.description + " ⏎")
            displayValue = result
        } else {
            displayValue = 0
        }
    }
    
    func checkBrainOnErrors(eval:(Double?, String?))->Double?{
        let(result, errorName) = eval
        if let error = errorName{
            displayResult = error
        } else {
            return result
        }
        return nil
    }
    
    func addToHistory (value:String)
    {
        displayHistory.text! = "\(value)"
    }
}

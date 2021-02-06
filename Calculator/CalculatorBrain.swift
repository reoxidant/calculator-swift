//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Виталий Шаповалов on 21.01.2021.
//  Copyright © 2021 Виталий Шаповалов. All rights reserved.
//

import Foundation

class CalculatorBrain{
    
    private enum Op {
        case Operand(Double)
        case UnaryOperation(String, (Double) -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        case ConstOperation(String, () -> Double)
        
        var description: String
        {
            get {
                switch self {
                case .Operand(let operand): return "\(operand)"
                case .UnaryOperation(let symbol, _): return symbol
                case .BinaryOperation(let symbol, _): return symbol
                case .ConstOperation(let symbol, _):return symbol
                }
            }
        }
    }
    init(){
        func learnOps(op:Op){
            knowsOps[op.description] = op
        }
        learnOps(op:Op.BinaryOperation("×", *))
        learnOps(op:Op.BinaryOperation("÷"){$1 / $0})
        learnOps(op:Op.BinaryOperation("+", +))
        learnOps(op:Op.BinaryOperation("-"){$1 - $0})
        learnOps(op:Op.UnaryOperation("√", sqrt))
        learnOps(op:Op.UnaryOperation("sin", sin))
        learnOps(op:Op.UnaryOperation("cos", cos))
        learnOps(op:Op.UnaryOperation("+/-", { operand in (operand > 0) ? operand * -1 : abs(operand) }))
        learnOps(op:Op.UnaryOperation("%"){$0 / 100})
        learnOps(op:Op.ConstOperation("π") { Double.pi })
    }
    
    private var opStack = [Op]()
    private var knowsOps = [String:Op]()
    
    private func evaluate(ops:[Op]) -> (result:Double?, remainingOps:[Op]){
        
        if !ops.isEmpty{
            var remainingOps = ops
            let op = remainingOps.removeLast();
            
            switch op {
            case .Operand(let operand):
                
                //MARK: do if u will click on enter or if u click on operation - first take a operate number to do the enter function and later add into opStack. In case operation take it first for the switch statement to recurse calculate value
                
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(ops:remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Eval = evaluate(ops:remainingOps)
                if let operand1 = op1Eval.result{
                    let op2Eval = evaluate(ops:op1Eval.remainingOps)
                    if let operand2 = op2Eval.result{
                        return (operation(operand1, operand2), op2Eval.remainingOps)
                    }
                }
            case .ConstOperation(_, let operation):
                return (operation(), remainingOps)
            }
        }
        
        return (nil, ops)
    }
    
    func pushOperand(operand:Double) -> Double?{
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    var variableValues = [String:Double]()
    
    func pushOperand(operand:String) -> Double?{
        if let variableOperand = variableValues[operand]{
            opStack.append(Op.Operand(variableOperand))
            return evaluate()
        } else {
            return nil
        }
    }
    
    func performOperation(symbol:String)->Double?{
        if let operation = knowsOps[symbol]{
            opStack.append(operation)
        }
        return evaluate()
    }
    
    func evaluate() -> Double?{
        let(result, _) = evaluate(ops:opStack)
        //if let result = result {
        //  print("result = \(result), remainingOps = \(remainingOps)")
        //}
        return result
    }
    
    func removeStack(){
        opStack = [Op]()
        _ = evaluate()
    }
    
    func convertNegOrPosValue(value:Double? = nil) -> Double{
        if value != nil{
            if value! > 0{
                return -value!
            } else {
                return abs(value!)
            }
        } else {
            return 0
        }
    }
}

//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Caroline O'Connor on 01/03/2015.
//  Copyright (c) 2015 Caroline O'Connor. All rights reserved.
//

import Foundation

// Bass class, doesnt need to inherite anything
class CalculatorBrain
{

    // For basic types
    // : Printable - this is called a protocol - enum implements what ever is in this protocol which is the computed property called description which returns a string
    private enum Op: Printable
    {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BineryOperation(String, (Double, Double) -> Double)
        
        // readonly description therefore no set is required
        var description: String {
            get {
                // return the op as a string by using a switch on myself
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BineryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    // An Array of Op
    private var opStack = [Op]()
    
    // For the Dictionary, it has a key and value seperated by a colon
    // e.g. Dictionary<String, Op>()
    private var knownOps = [String:Op]()
    
    
    // initise the knownOps
    init() {
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        learnOp(Op.BineryOperation("×", *))
        learnOp(Op.BineryOperation("÷") { $1 / $0 })
        learnOp(Op.BineryOperation("+", +))
        learnOp(Op.BineryOperation("−") { $1 - $0 })
        learnOp(Op.UnaryOperation("√", sqrt))
    }
            
    // tupils - combine multiple things together
    // return 2 things - result & the stack
    // Good to name the return types
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op])
    {
        // check that the ops is not empty
        if !ops.isEmpty {
            
            // takes a copy of ops and puts it in remainingOps. var makes it mutiable.
            var remainingOps = ops
            // grab the first op from the stack
            let op = remainingOps.removeLast()
            
            // switch is used to pull things out of enums in Swift
            switch op {
            // operand is going to have the associated value of the operand
            case .Operand(let operand):
                // return operand - the result
                return (operand, remainingOps)
            // _ -an underbar means I dont care about that
            case .UnaryOperation(_, let operation):
                // get the operand through recurrsion. calls a func that returns a tupil
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BineryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 =  op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1,operand2), op2Evaluation.remainingOps)
                    }
                }
                
            }
            
        }
        // return default result nil if I failed
        // If you run out of stack, it is going to fall out here and return nil.
        return (nil, ops)
    }
        
    // evaluate this opStack and retun the value
    // return an optional double e.g. evaluate + might need to return nil therefore needs to be an optional.
    func evaluate() -> Double? {
            //use recurrsion to evalutate this, keep going recurrsively to get all the arguments.
            // let a tupil = to the result
            let (result, remainder) = evaluate(opStack)
            println("\(opStack) = \(result) with \(remainder) left over")
            return result
        }
        

    // when you push an operand it returns evaluate
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
        
    }
}
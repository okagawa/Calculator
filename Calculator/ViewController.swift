//
//  ViewController.swift
//  Calculator
//
//  Created byHiroshi on 2015/05/08.
//  Copyright (c) 2015年 Hiroshi Okagawa. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false

    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            if !(digit == "." && display.text!.range(of: ".") != nil ) {
//            if !(digit == "." && display.text!.rangeOfString(".") != nil ) {
                display.text = display.text! + digit
            }
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }

    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        switch operation {
        case "×": performOperation (operation: { $0 * $1 }, op:operation)
        case "÷": performOperation (operation: { $1 / $0 }, op:operation)
        case "+": performOperation (operation: { $0 + $1 }, op:operation)
        case "−": performOperation (operation: { $1 - $0 }, op:operation)
        case "√": performOperation (operation: { sqrt($0) }, op:operation)
        case "sin": performOperation (operation: { sin($0) }, op:operation)
        case "cos": performOperation (operation: { cos($0) }, op:operation)
        case "π": displayValue = Double.pi
                  enter()
        case "C": displayValue = 0.0
                  historyValue = " "
                  userIsInTheMiddleOfTypingANumber = false
        operandStack.removeAll(keepingCapacity: false)
        default: break
        }
    }
    
    private func performOperation(operation: (Double, Double) -> Double, op:String) {
        if operandStack.count >= 2 {
            var histValueTmp = operandStack.map({ $0.description })
            historyValue = histValueTmp.reduce("", combine:{ $0 + " " + $1 }) + " " + op
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
 
    private func performOperation(operation: (Double) -> Double, op:String) {
        if operandStack.count >= 1 {
            var histValueTmp = operandStack.map({ $0.description })
            historyValue = histValueTmp.reduce("", combine:{ $0 + " " + $1 }) + " " + op
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    var operandStack = Array<Double>()
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        operandStack.append(displayValue)
        print("operandStack = \(operandStack)")
    }
    
    var displayValue: Double {
        get {
            return NumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
    
    var historyValue: String {
        get {
            return(history.text!)
        }
        set {
            history.text = newValue
        }
    }
    
}


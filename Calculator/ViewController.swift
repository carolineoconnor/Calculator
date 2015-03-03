    //
    //  ViewController.swift
    //  Calculator
    //
    //  Created by Caroline O'Connor on 22/02/2015.
    //  Copyright (c) 2015 Caroline O'Connor. All rights reserved.
    //

    import UIKit

    class ViewController: UIViewController
    {
        
        // why does this not need to be initialised?
        // it is optional therefore is equals nil when this var gets set early add an ! to always unwrap it. implecilly unwrapped optional
        @IBOutlet weak var display: UILabel!
        
        // remove the leading 0 in the display
        // adding a property
        // :type
        // All properties have to be initialised, they have to have a value.
        var userisinthemiddleoftypinganumber = false
        var userisNotTypingAfterDecimalPoint = false
        
        // The green arrow that goes from the Controller to the Model in MVC
        var brain = CalculatorBrain()
        
        
        @IBAction func appendDigit(sender: UIButton){
            //let is a constant and digit will never be changed
            let digit = sender.currentTitle!
            if userisinthemiddleoftypinganumber {
                
                // As display.text is an optional string thats why theres an error
                // you cant add a string to an optional string only other strings
                // need to turn the OS into a string by unwrapping display.text!. Program will
                // crash if the display currently has nothing in it or is not set.
                display.text = display.text! + digit
                
            } else {
                display.text = digit
                userisinthemiddleoftypinganumber = true
                
            }
            
        }
        
        @IBAction func appendDecimal(sender: UIButton){
            if !userisNotTypingAfterDecimalPoint {
                appendDigit(sender)
                userisNotTypingAfterDecimalPoint = true
            }
            
            
        }
        
        @IBAction func operate(sender: UIButton) {
            
            if userisinthemiddleoftypinganumber {
                enter()
            }
            // String to tell the title of the button
            
            if let operation = sender.currentTitle {
                if let result = brain.performOperation(operation) {
                    displayValue = result
                } else {
                    displayValue = 0
                }
            }
            
        }
        
        
        // put what ever number we have on the display in to the internal stack
        // Set users when typing a number to false
        // appends digit - right click to disconnect connections.
        @IBAction func enter() {
            userisinthemiddleoftypinganumber = false
            // need to push the operand onto the stack
            if let result = brain.pushOperand(displayValue) {
                // if it is not nil, i am going to set the displayValue to the result
                displayValue = result
            } else {
                displayValue = 0
                // really want to say displayValue = nil
                // or puts an error message in my display
            }
            
        }
        
        // computted properties
        var displayValue: Double {
            // return the display value
            get{
                // bring in display.text and unwrap it
                // result is optional therefore unwrap that
                // on the return numberFromString is a number and doubleValue turns it into a double
                return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
            }
            set{
                //convert newValue double to a string
                display.text = "\(newValue)"
                // not in the middle of typig a number anymore
                userisinthemiddleoftypinganumber = false
            }
        }
        
        
        // for example(56.0, 7.0,8.0)
        // if you have operand + it would add 7.0 + 8.0 = 15 and would then add put the 15 on the stack
        // which is 56 + 15 = 71
        
    }


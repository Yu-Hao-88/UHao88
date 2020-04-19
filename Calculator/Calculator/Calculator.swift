//
//  Calculator.swift
//  Calculator
//
//  Created by 曾羭豪 on 2020/4/19.
//  Copyright © 2020 Yu Hao Tseng. All rights reserved.
//

import Foundation

class Calculator {
    var numberOnScreen :Double      //要存目前畫面上的數字
    var previousNumber :Double     //要存的運算之前畫面上的數字
    var performingMath :Bool //要記錄目前是不是在運算過程中
    
    enum OperationType{
        case add
        case subtract
        case multiply
        case divide
        case none
    }
    var operation: OperationType
    
    init(){
        numberOnScreen = 0
        previousNumber = 0
        performingMath = false
        operation = .none
    }
    func clear() {
        numberOnScreen = 0
        previousNumber = 0
        performingMath = false
        operation = .none
    }
    func setNumberOnSceen(_ text: String) {
        numberOnScreen = Double(text) ?? 0
    }
    func counting(_ tag: Int)  {
        performingMath = true
        previousNumber = numberOnScreen
        switch tag {
        case 1:
            operation = .divide
        case 2:
            operation = .multiply
        case 3:
            operation = .subtract
        case 4:
            operation = .add
        default:
            operation = .none
        }
    }
    func answer() -> String{
        var temp :Double = numberOnScreen
        if performingMath == true{
            switch operation {
            case .add:
                temp = previousNumber+numberOnScreen
            case .subtract:
                temp = previousNumber-numberOnScreen
            case .divide:
                temp = previousNumber/numberOnScreen
            case .multiply:
                temp = previousNumber*numberOnScreen
            default:
                temp = 0
            }
            performingMath = false
        }
        
        if !isDouble(temp){
            return "\(Int(temp))"
        }
        else{
            return "\(temp)"
        }
    }
    func isDouble(_ number: Double) -> Bool{
        if floor(number) == number{
            return false
        }
        else{
            return true
        }
    }
    func calPercentage() -> String{
        numberOnScreen = numberOnScreen/100
        return "\(numberOnScreen)"
    }
    func positiveNegative() -> String{
        numberOnScreen = -numberOnScreen
        if isDouble(numberOnScreen){
            return "\(numberOnScreen)"
        }
        else{
            return "\(Int(numberOnScreen))"
        }
        
    }
}

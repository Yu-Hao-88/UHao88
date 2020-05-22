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
    var performingMath :Bool        //要記錄目前是不是在運算過程中
    var labelUpdate :Bool          //判斷是否需要更改label
    
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
        labelUpdate = false
    }
    func clear() {
        numberOnScreen = 0
        previousNumber = 0
        performingMath = false
        operation = .none
        labelUpdate = false
    }
    func getLabelUpdate() -> Bool{
        return labelUpdate
    }
    func setLabelUpdate(_ set: Bool){
        labelUpdate = set
    }
    func setNumberOnSceen(_ text: String) {
        numberOnScreen = Double(text) ?? 0
    }
    func enterOperation(_ tag: Int)  {
        if !labelUpdate{
            counting()
        }
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
    func counting(){
        if performingMath == true{
            switch operation {
            case .add:
                numberOnScreen = previousNumber+numberOnScreen
            case .subtract:
                numberOnScreen = previousNumber-numberOnScreen
            case .divide:
                numberOnScreen = previousNumber/numberOnScreen
            case .multiply:
                numberOnScreen = previousNumber*numberOnScreen
            default:
                numberOnScreen = 0
            }
            performingMath = false
        }
    }
    func answer() -> String{
        counting()
        let temp :Double = numberOnScreen
        
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

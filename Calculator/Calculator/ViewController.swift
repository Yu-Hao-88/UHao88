//
//  ViewController.swift
//  Calculator
//
//  Created by 曾羭豪 on 2020/4/18.
//  Copyright © 2020 Yu Hao Tseng. All rights reserved.
//

import UIKit
class ViewController: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    var calculator:Calculator = Calculator()
    var labelUpdate = false
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var buttomOfC: UIButton!
    
    @IBAction func numbers(_ sender: UIButton) {
        let inputNumber = sender.tag-1
        
        if label.text != nil{
            if label.text == "0" || labelUpdate{
                if inputNumber != 0 || labelUpdate{
                    label.text = "\(inputNumber)"
                    buttomOfC.setTitle("C", for: .normal)
                    labelUpdate = false
                }
            }
            else{
                label.text = label.text!  + "\(inputNumber)"
            }
            calculator.setNumberOnSceen(label.text!)
        }
    }
    
    @IBAction func dot(_ sender: UIButton) {
        if label.text != nil{
            if !calculator.isDouble( Double(label.text!) ?? 0){
                label.text = label.text!  + "."
            }
        }
    }
    
    @IBAction func percentage(_ sender: UIButton) {
        label.text = calculator.calPercentage()
    }
    
    @IBAction func positiveNegative(_ sender: UIButton) {
        label.text = calculator.positiveNegative()
    }
    
    @IBAction func clear(_ sender: UIButton) {
        label.text = "0"
        buttomOfC.setTitle("AC", for: .normal)
        calculator.clear()
        
    }
    
    @IBAction func operation(_ sender: UIButton) {
        calculator.counting(sender.tag)
        labelUpdate = true
    }
    @IBAction func answer(_ sender: UIButton) {
        label.text = calculator.answer()
        calculator.setNumberOnSceen(label.text!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}


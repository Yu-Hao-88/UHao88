//
//  ViewController.swift
//  Calculator
//
//  Created by 曾羭豪 on 2020/4/18.
//  Copyright © 2020 Yu Hao Tseng. All rights reserved.
//

import UIKit
class CalaulatorController: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    var calculator:Calculator = Calculator()
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var buttomOfC: UIButton!
    @IBOutlet var buttomOfOperator: [UIButton]!
    
    func setLabelColor(){
        for buttom in buttomOfOperator {
            buttom.backgroundColor = UIColor.systemOrange
            buttom.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        }
    }
    
    @IBAction func numbers(_ sender: UIButton) {
        let inputNumber = sender.tag-1
        
        if label.text != nil{
            if label.text == "0" || calculator.getLabelUpdate(){
                if inputNumber != 0 || calculator.getLabelUpdate(){
                    label.text = "\(inputNumber)"
                    buttomOfC.setTitle("C", for: .normal)
                    calculator.setLabelUpdate(false)
                    setLabelColor()
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
        calculator.setLabelUpdate(false)
        setLabelColor()
    }
    
    
   
    
    @IBAction func operation(_ sender: UIButton) {
        setLabelColor()
        buttomOfOperator[sender.tag-1].backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        buttomOfOperator[sender.tag-1].setTitleColor(UIColor.systemOrange, for: .normal)
        calculator.enterOperation(sender.tag)
        calculator.setLabelUpdate(true)
    }
    @IBAction func answer(_ sender: UIButton) {
        label.text = calculator.answer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}


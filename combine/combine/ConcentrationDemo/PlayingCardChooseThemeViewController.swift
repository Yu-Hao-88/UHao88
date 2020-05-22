//
//  PlayingCardChooseThemeViewController.swift
//  ConcentrationDemo
//
//  Created by 曾羭豪 on 2020/5/21.
//  Copyright © 2020 Ko-Chih Wang. All rights reserved.
//

import UIKit

class PlayingCardChooseThemeViewController: UIViewController, UISplitViewControllerDelegate {
    let themes = [
        "Sports": "⚽️🏀🏈⚾️🎾🏐🎱🥏",
        "Faces": "😀☺️🥰😜😏😣😠😨",
        "PokerCards":"♠️❤️♦️♣️"
    ]
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController,
        onto primaryViewController: UIViewController)
        -> Bool {
            if let cvc = secondaryViewController as? PlayCardController{
                if cvc.theme == nil{
                    return true
                }
            }
            return false
    }
    
    override func awakeFromNib() {
        splitViewController?.delegate = self
    }
    
    @IBAction func changeTheme(_ sender: Any) {
        if let cvc = splitViewDetailConcentrationViewController{
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName]{
                cvc.theme = theme
            }
        } else if let cvc = lastSeguedToConcentrationViewController{
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName]{
                cvc.theme = theme
            }
            navigationController?.pushViewController(cvc, animated: true)
        }
        else{
            performSegue(withIdentifier: "Choose Theme", sender: sender)
        }
    }
    
    private var splitViewDetailConcentrationViewController: PlayCardController?{
        return splitViewController?.viewControllers.last as? PlayCardController
    }
    
    private var lastSeguedToConcentrationViewController: PlayCardController?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Choose Theme" {
            if let button = sender as? UIButton{
                if let themeName = button.currentTitle{
                    if let theme = themes[themeName]{
                        if let cvc = segue.destination as? PlayCardController{
                            cvc.theme = theme
                            lastSeguedToConcentrationViewController = cvc
                        }
                    }
                }
            }
        }
    }
}

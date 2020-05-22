//
//  ViewController.swift
//  PlayingCard
//
//  Created by Ko-Chih Wang on 2020/4/7.
//  Copyright © 2020 Ko-Chih Wang. All rights reserved.
//

import UIKit

class PlayCardController: UIViewController {
    
    var deck = PlayingCardDeck()
    
    @IBOutlet var cardViews: [PlayingCardView]!
    
    lazy var animator = UIDynamicAnimator(referenceView: view)
    
    lazy var cardBehavior = CardBehavior(in: animator)
    
    private var emojiChoice = "♠️❤️♦️♣️"
    
    var theme: String?{
        didSet{
            emojiChoice = theme ?? ""
            print(emojiChoice)
            if(cardViews != nil)
            {
                for cardView in cardViews{
                cardView.isFaceUp = false
                let index = emojiChoice.index(emojiChoice.startIndex, offsetBy: cardView.rank%emojiChoice.count  )
                cardView.suit = String(emojiChoice[index])
                
                cardBehavior.addItem(cardView)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var cards = [PlayingCard]()
        
        for _ in 1...((cardViews.count+1)/2){
            let card = deck.draw()!
            cards += [card, card]
        }
    
        for cardView in cardViews{
            cardView.isFaceUp = false
            let card = cards.remove(at: cards.count.arc4random)
            cardView.rank = card.rank.order
            //cardView.suit = card.suit.rawValue
            let index = emojiChoice.index(emojiChoice.startIndex, offsetBy: cardView.rank%emojiChoice.count  )
            cardView.suit = String(emojiChoice[index])
            print(card.rank.order,card.suit.rawValue)
            cardView.addGestureRecognizer(
                UITapGestureRecognizer(
                    target: self, action: #selector(flipCard(_:) ) ))
            
            cardBehavior.addItem(cardView)
        }
    }

    private var faceUpCardViews: [PlayingCardView]{
        return cardViews.filter{ $0.isFaceUp && !$0.isHidden }
    }

    private var faceUpCardViewMatch: Bool{
        return faceUpCardViews.count == 2 && faceUpCardViews[0].rank == faceUpCardViews[1].rank && faceUpCardViews[0].suit == faceUpCardViews[1].suit
    }
    
    @objc func flipCard(_ recognizer: UITapGestureRecognizer){
        switch recognizer.state{
        case .ended:
            if let chosenCardView = recognizer.view as? PlayingCardView{
                UIView.transition(with: chosenCardView,
                                  duration: 0.6,
                                  options: [.transitionFlipFromLeft],
                                  animations: {
                                    chosenCardView.isFaceUp = !chosenCardView.isFaceUp
                                    },
                                    completion: { _ in
                                        if self.faceUpCardViewMatch{
                                            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.6,
                                                                                           delay: 0,
                                                                                           options: [],
                                                                                           animations: { self.faceUpCardViews.forEach{
                                                                                            $0.transform = CGAffineTransform.identity.scaledBy(x: 3.0, y: 3.0)
                                                                                                }
                                                                                            },
                                                                                            completion:{ _ in
                                                                                                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.75,
                                                                                                delay: 0,
                                                                                                options: [],
                                                                                                animations: { self.faceUpCardViews.forEach{
                                                                                                    $0.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
                                                                                                    $0.alpha = 0
                                                                                                 }
                                                                                                 },
                                                                                                completion: { _ in
                                                                                                    self.faceUpCardViews.forEach{
                                                                                                        $0.isHidden = true
                                                                                                        $0.alpha = 1
                                                                                                        $0.transform = .identity
                                                                                                    }
                                                                                                    
                                                                                                }
                                                                                                )
                                                                                                }
                                                                                        )
                                                                                           
                                        }
                                        else if self.faceUpCardViews.count == 2{
                                            self.faceUpCardViews.forEach{ cardView in
                                                UIView.transition(with: cardView,
                                                                  duration: 0.6,
                                                                  options: [.transitionFlipFromLeft],
                                                                  animations: {
                                                                    cardView.isFaceUp = false
                                                                    }
                                                    )
                                            }
                                        }
                                        
                                    }
                                  )
            }
        default:
            break
        }
    }
    
}


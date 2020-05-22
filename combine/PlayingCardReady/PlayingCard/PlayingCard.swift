//
//  File.swift
//  PlayingCard
//
//  Created by Ko-Chih Wang on 2020/4/7.
//  Copyright © 2020 Ko-Chih Wang. All rights reserved.
//

import Foundation

struct PlayingCard : CustomStringConvertible
{
    var description: String{return "\(rank)\(suit)"}
    
    var suit: Suit
    var rank: Rank
    
    enum Suit: String, CustomStringConvertible{
        var description: String {return rawValue}
        
        case spade = "♠️"
        case heart = "❤️"
        case diamond = "♦️"
        case club = "♣️"
        
        static var all = [Suit.spade, .heart, .diamond, .club]
    }
    
    enum Rank: CustomStringConvertible{
        var description: String{
            switch self{
            case .ace: return "A"
            case .numeric(let pips): return String(pips)
            case .face(let kind): return kind
            }
        }
        
        case ace
        case numeric(pipsCount: Int)
        case face(String)
        
        var order: Int{
            switch self{
            case .ace: return 1
            case .numeric(let pips): return pips
            case .face(let kind) where kind == "J": return 11
            case .face(let kind) where kind == "Q": return 12
            case .face(let kind) where kind == "K": return 13
            default: return 0
            }
        }
        
        static var all: [Rank]{
            var allRanks = [Rank.ace]
            for pips in 2...10{
                allRanks.append(Rank.numeric(pipsCount: pips))
            }
            allRanks += [Rank.face("J"), Rank.face("Q"), Rank.face("K") ]
            return allRanks
        }
    }
}

//
//  FlowState.swift
//  FlowEngine
//
//  Created by Diego Flores Domenech on 4/8/20.
//  Copyright © 2020 Diego Flores. All rights reserved.
//

import Foundation

enum CardType: String {
    case credit = "credit_card"
    case debit = "debit_card"
}

class FlowState: NSObject{
    var amount: Double?
    var description: String?
    var installments: [Int]?
    var cardType: CardType?
    var cart: [Cart]?
}

struct Cart {
    let id: String
    let price: Double
    let count: Int
}

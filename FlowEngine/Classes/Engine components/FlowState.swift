//
//  FlowState.swift
//  FlowEngine
//
//  Created by Diego Flores Domenech on 4/8/20.
//  Copyright © 2020 Diego Flores. All rights reserved.
//

import Foundation

//public enum CardType: String {
//    case credit = "credit_card"
//    case debit = "debit_card"
//}

class FlowState {
    private(set) var amount: Double?
    private(set) var description: String?
    private(set) var installments: Int?
    private(set) var cardType: String?
    private(set) var cart: [Cart]?
    private(set) var showedPaymentResult: Bool?
    
    func setAttributes(_ attributes: [Attribute]) {
        attributes.forEach({self.setField(id: $0.fieldId, value: $0.value)})
    }
    
    func setField(id: FieldId, value: Any?) {
        //TODO: ver de mejorar esto
        let propName = id.mirror.label
        switch propName {
        case "amount":
            self.amount = value as? Double
        case "description":
            self.description = value as? String
        case "installments":
            self.installments = value as? Int
        case "cardType":
            self.cardType = value as? String
        case "cart":
            self.cart = value as? [Cart]
        case "showedPaymentResult":
            self.showedPaymentResult = value as? Bool
        default:
            break
        }
        
//        let mirror = Mirror(reflecting: self)
//        let childProp = mirror.children.first(where: {$0.label == propName})
//        guard type(of: childProp?.value) == type(of: value) else {
//            return
//        }
//        self[keyPath: \FlowState.amount] = value
    }
    
    func getFieldValue(id: FieldId) -> Any? {
        let propName = id.mirror.label
        let mirror = Mirror(reflecting: self)
        let childProp = mirror.children.first(where: {$0.label == propName})
        return childProp?.value
    }
    
    var fulfilledFields: [FieldId] {
        FieldId.allCases.filter({self.getFieldValue(id: $0) != nil })
    }
}

struct Cart {
    let id: String
    let price: Double
    let count: Int
}

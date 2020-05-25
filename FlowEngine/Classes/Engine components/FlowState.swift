//
//  FlowState.swift
//  FlowEngine
//
//  Created by Diego Flores Domenech on 4/8/20.
//  Copyright © 2020 Diego Flores. All rights reserved.
//

import Foundation

public enum CardType: String {
    case credit = "credit_card"
    case debit = "debit_card"
}

class FlowState: NSObject {
    private(set) var amount: Double?
    private(set) var descr: String?
    private(set) var installments: [Int]?
    private(set) var cardType: CardType?
    private(set) var cart: [Cart]?
    private(set) var showedPaymentResult = false
    
    func setAttributes(_ attributes: [Attribute]) {
        attributes.forEach({self.setField(id: $0.fieldId, value: $0.value)})
    }
    
    func setField(id: FieldId, value: Any?) {
        let propName = id.mirror.label
        let mirror = Mirror(reflecting: self)
        let childProp = mirror.children.first(where: {$0.label == propName})
        guard type(of: childProp?.value) == type(of: value) else {
            return
        }
        self.setValue(value, forKey: propName)
    }
    
    func getFieldValue(id: FieldId) -> Any? {
        let propName = id.mirror.label
        let mirror = Mirror(reflecting: self)
        let childProp = mirror.children.first(where: {$0.label == propName})
        return childProp?.value
    }
    
}

struct Cart {
    let id: String
    let price: Double
    let count: Int
}

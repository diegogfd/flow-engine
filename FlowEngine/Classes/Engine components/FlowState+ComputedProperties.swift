//
//  FlowState+ComputedProperties.swift
//  FlowEngine
//
//  Created by Diego Flores Domenech on 6/4/20.
//

import Foundation

// para acceder (read-only) al valor de los fields más cómodamente y sin tener que castear el resultado de getFieldValue(id: field), podemos definir computed properties

extension FlowState {
    
    var amount: Double? {
        return self.getFieldValue(id: .amount) as? Double
    }
    
    var description: String? {
        return self.getFieldValue(id: .description) as? String
    }
    
    var installments: Int? {
        return self.getFieldValue(id: .installments) as? Int
    }
    
    var cardType: CardType? {
        return self.getFieldValue(id: .cardType) as? CardType
    }
    
}

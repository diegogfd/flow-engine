//
//  FlowState.swift
//  FlowEngine
//
//  Created by Diego Flores Domenech on 4/8/20.
//  Copyright © 2020 Diego Flores. All rights reserved.
//

import Foundation

public enum CardType: String, StringRawRepresentable {
    case credit = "credit_card"
    case debit = "debit_card"
}

public struct FlowState {
    
    private var innerState: [FieldId : Any] = [:]
    
    mutating func setAttributes(_ attributes: [Attribute]) {
        attributes.forEach({self.setField(id: $0.fieldId, value: $0.value)})
    }
    
    mutating func setField(id: FieldId, value: Any?) {
        self.innerState[id] = value
    }
    
    public func getFieldValue(id: FieldId) -> Any? {
        //si definimos un field que sea derivado de otro objeto que guardemos en el state (por ejemplo, una rule que evalue el on_site_allowed del payment_method), aqui deberiamos definir como se obtiene el valor
        return self.innerState[id]
    }
    
    var fulfilledFields: [FieldId] {
        FieldId.allCases.filter({ return self.getFieldValue(id: $0) != nil })
    }
}

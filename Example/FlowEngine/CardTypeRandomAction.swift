//
//  CardTypeRandomAction.swift
//  FlowEngine_Example
//
//  Created by Diego Flores Domenech on 5/25/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import FlowEngine

class CardTypeRandomAction : Action {
    
    var id: ActionId = .cardTypeRandom
    var flowEngine: FlowEngine!
    
    func execute(for fields: [FieldId]) {
        let isCredit = Bool.random()
        print("SALIO \(isCredit ? "CREDITO" : "DEBITO")")
        self.flowEngine.updateFlowState(fieldId: .cardType, value: isCredit ? CardType.credit : CardType.debit)
        self.flowEngine.goNext()
    }
    
}

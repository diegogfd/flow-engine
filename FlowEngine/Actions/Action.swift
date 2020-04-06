//
//  Action.swift
//  FlowEngine
//
//  Created by Diego Flores Domenech on 3/29/20.
//  Copyright © 2020 Diego Flores. All rights reserved.
//

import Foundation

protocol ActionAssociated {
    var action: Action { get }
}

protocol Action : class, FlowEngineComponent {
    func execute()
    var fields: [ActionField] { get }
}

struct ActionField {
    enum Priority: Int {
        case veryLow
        case low
        case medium
        case high
        case veryHigh
        case critical
    }
    let name: Field.Name
    let priority: Priority
}

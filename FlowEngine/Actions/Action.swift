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

enum ActionId: String {
    case calculator
    case cardTypeSelection
    case installmentsSelection
}

protocol Action : class, FlowEngineComponent {
    func execute()
    var id: ActionId { get }
    var fieldIds: [FieldId] { get }
}

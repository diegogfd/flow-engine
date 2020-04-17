//
//  Action.swift
//  FlowEngine
//
//  Created by Diego Flores Domenech on 3/29/20.
//  Copyright © 2020 Diego Flores. All rights reserved.
//

import Foundation

public protocol ActionAssociated {
    var action: Action { get }
}

public enum ActionId: String {
    case amountDescriptionScreen
    case cardTypeSelection
    case installmentsSelection
}

public protocol Action : class, FlowEngineComponent {
    func execute(for fields: [FieldId])
    var id: ActionId { get }
    var fieldIds: [FieldId] { get }
}

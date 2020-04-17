//
//  AmountDescriptionViewControllerAction.swift
//  FlowEngine_Example
//
//  Created by Diego Flores Domenech on 4/14/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import FlowEngine

class AmountDescriptionViewControllerAction: NavigationAction {
    
    var id: ActionId = .amountDescriptionScreen
    var fieldIds: [FieldId] = [.amount, .descr]
    var flowEngine: FlowEngine!
    var enabledFieldIds: [FieldId] = []
    
    private let navigationController: UINavigationController
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func execute(for fields: [FieldId]) {
        self.enabledFieldIds = fields
    }
    
}

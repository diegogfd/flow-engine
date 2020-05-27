//
//  SimpleCongratsAction.swift
//  FlowEngine_Example
//
//  Created by Diego Flores Domenech on 5/25/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import FlowEngine

class SimpleCongratsAction : NavigationAction {
    
    var id: ActionId = .simpleCongrats
    var fieldIds: [FieldId] = [.showedPaymentResult]
    var flowEngine: FlowEngine!
    let navigationController: UINavigationController
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func execute(for fields: [FieldId]) {
        let viewController = SimpleCongratsViewController(flowEngine: self.flowEngine)
        self.navigationController.pushViewController(viewController, animated: true)
    }
}

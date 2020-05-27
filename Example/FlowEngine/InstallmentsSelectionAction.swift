//
//  InstallmentsSelectionAction.swift
//  FlowEngine_Example
//
//  Created by Diego Flores Domenech on 5/27/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import FlowEngine

class InstallmentsSelectionAction: NavigationAction {
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    var fieldIds: [FieldId] = [.installments]
    var id: ActionId = .installmentsSelection
    let navigationController: UINavigationController
        
    var flowEngine: FlowEngine!
    
    func execute(for fields: [FieldId]) {
        let viewController = InstallmentsSelectionViewController(flowEngine: self.flowEngine)
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
}

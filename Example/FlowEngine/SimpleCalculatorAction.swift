//
//  SimpleCalculatorAction.swift
//  FlowEngine_Example
//
//  Created by Diego Flores Domenech on 5/25/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import FlowEngine

class SimpleCalculatorAction: NavigationAction {
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    var id: ActionId = .simpleCalculator
    let navigationController: UINavigationController
        
    var flowEngine: FlowEngine!
    
    func execute() {
        let viewController = SimpleCalculatorViewController(flowEngine: self.flowEngine)
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
}

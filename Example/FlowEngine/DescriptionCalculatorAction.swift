//
//  DescriptionCalculatorAction.swift
//  FlowEngine_Example
//
//  Created by Diego Flores Domenech on 5/27/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import FlowEngine

class DescriptionCalculatorAction: NavigationAction {
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    var id: ActionId = .descriptionCalculator
    let navigationController: UINavigationController
        
    var flowEngine: FlowEngine!
    
    func execute() {
        let viewController = DescriptionCalculatorViewController(flowEngine: self.flowEngine)
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
}

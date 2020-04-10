//
//  FirstViewControllerAction.swift
//  FlowEngine
//
//  Created by Diego Flores Domenech on 4/1/20.
//  Copyright © 2020 Diego Flores. All rights reserved.
//

import Foundation
import UIKit

class FirstViewControllerAction : NavigationAction {
    unowned var flowEngine: FlowEngine!    
    var navigationController: UINavigationController
    var fields: [Field.Name] {
        return [
            .setAmount
        ]
    }
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func execute() {
        let viewController = FirstViewController(action: self)
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    func setAmount(_ amount: Double) -> ValidationError? {
        return self.flowEngine.fulfillField(name: .setAmount, value: amount)
    }
}

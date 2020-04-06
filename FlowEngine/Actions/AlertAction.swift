//
//  AlertAction.swift
//  FlowEngine
//
//  Created by Diego Flores Domenech on 4/1/20.
//  Copyright © 2020 Diego Flores. All rights reserved.
//

import Foundation
import UIKit

class AlertAction : NavigationAction {
    
    unowned var flowEngine: FlowEngine!
    
    let navigationController: UINavigationController
    var fields: [ActionField] {
        return [
                ActionField(name: .setDescription, priority: .high),
                ActionField(name: .setAmount, priority: .veryLow)
            ]
    }
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func execute() {
        let alertController = UIAlertController(title: "Alert de prueba", message: "Ingresa descripcion", preferredStyle: .alert)
        self.navigationController.present(alertController, animated: true, completion: nil)
    }
    
}

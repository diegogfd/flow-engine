//
//  DescriptionDialogAction.swift
//  FlowEngine_Example
//
//  Created by Diego Flores Domenech on 5/25/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import FlowEngine

class DescriptionDialogAction : NavigationAction {
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func execute(for fields: [FieldId]) {
        let alertController = UIAlertController(title: "Ingresa la descripción", message: nil, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Descripción"
        }
        let alertAction = UIAlertAction(title: "Listo", style: .default) { [weak self] (action) in
            guard let self = self else {
                return
            }
            let description = alertController.textFields?.first?.text
            self.flowEngine.updateFlowState(fieldId: .description, value: description)
            self.navigationController.dismiss(animated: true) { [weak self] in
                self?.flowEngine.goNext()
            }
        }
        alertController.addAction(alertAction)
        self.navigationController.present(alertController, animated: true, completion: nil)
    }
    
    private let navigationController: UINavigationController
    var id: ActionId = .descriptionDialog
    
    var fieldIds: [FieldId] = [.description]
    
    var flowEngine: FlowEngine!
    
    
}

//
//  DescriptionCalculatorViewController.swift
//  FlowEngine_Example
//
//  Created by Diego Flores Domenech on 5/27/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import FlowEngine
import MLCommons

class DescriptionCalculatorViewController: MLBaseViewController, FlowEngineComponent {

    @IBOutlet var amountTextField: UITextField!
    @IBOutlet var descriptionTextField: UITextField!
    @IBOutlet var errorLabel: UILabel!
    var flowEngine: FlowEngine!
    
    init(flowEngine: FlowEngine) {
        self.flowEngine = flowEngine
        super.init(nibName: "DescriptionCalculatorViewController", bundle: nil)
        self.addBehaviour(FlowEngineBehaviour(flowEngine: flowEngine))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.amountTextField.delegate = self
        self.amountTextField.keyboardType = .decimalPad
        self.descriptionTextField.delegate = self
        self.errorLabel.isHidden = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGestureRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func didTapContinue() {
        self.flowEngine.updateFlowState(fieldId: .description, value: self.descriptionTextField.text)
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let amount = numberFormatter.number(from: self.amountTextField.text ?? "")?.doubleValue ?? 0
        let result = self.flowEngine.updateFlowState(fieldId: .amount, value: amount)
        if case .failure(let validationError) = result, case .failed(let failingValidations) = validationError, let validation = failingValidations.first {
            if validation.id == "amount_out_of_bounds" {
                self.errorLabel.text = "El monto debe ser mayor a 0 y menor a 50000"
            }
            self.errorLabel.isHidden = false
        } else {
            self.errorLabel.isHidden = true
            self.flowEngine.goNext()
        }
    }
}

extension DescriptionCalculatorViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
}


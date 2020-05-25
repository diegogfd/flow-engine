//
//  SimpleCalculatorViewController.swift
//  FlowEngine_Example
//
//  Created by Diego Flores Domenech on 5/25/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import FlowEngine

class SimpleCalculatorViewController: UIViewController {
    
    @IBOutlet var amountTextField: UITextField!
    @IBOutlet var errorLabel: UILabel!
    
    private let flowEngine: FlowEngine
    
    init(flowEngine: FlowEngine) {
        self.flowEngine = flowEngine
        super.init(nibName: "SimpleCalculatorViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.amountTextField.delegate = self
        self.amountTextField.keyboardType = .decimalPad
    }
    
    @IBAction func didTapContinue() {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let amount = numberFormatter.number(from: self.amountTextField.text ?? "")
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

extension SimpleCalculatorViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
}

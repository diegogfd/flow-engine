//
//  SimpleCongratsViewController.swift
//  FlowEngine_Example
//
//  Created by Diego Flores Domenech on 5/25/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import FlowEngine
import MLCommons

class SimpleCongratsViewController: MLBaseViewController, FlowEngineComponent {
    
    var flowEngine: FlowEngine!
    
    init(flowEngine: FlowEngine) {
        self.flowEngine = flowEngine
        super.init(nibName: "SimpleCongratsViewController", bundle: nil)
        self.addBehaviour(FlowEngineBehaviour())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.flowEngine.updateFlowState(fieldId: .showedPaymentResult, value: true)
    }
    
    @IBAction func didTapGoBack() {
        self.navigationController?.popToRootViewController(animated: true)
    }

}

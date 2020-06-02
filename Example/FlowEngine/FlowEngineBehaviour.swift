//
//  FlowEngineBehaviour.swift
//  FlowEngine_Example
//
//  Created by Diego Flores Domenech on 5/28/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import MLCommons
import FlowEngine

class FlowEngineBehaviour : MLBaseBehaviour {
    
    var flowEngineMemento: FlowEngine?
    private var isPresentingViewController = false
    
    override func viewDidLoad() {
        guard let viewController = self.viewController as? FlowEngineComponent else {
            return
        }
        self.flowEngineMemento = viewController.flowEngine
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        guard var viewController = self.viewController as? FlowEngineComponent, !self.isPresentingViewController else {
//            return
//        }
//        viewController.flowEngine = self.flowEngineMemento
//        self.isPresentingViewController = false
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        if !self.viewController.isMovingFromParentViewController {
//            self.isPresentingViewController = true
//        }
//    }
    
}

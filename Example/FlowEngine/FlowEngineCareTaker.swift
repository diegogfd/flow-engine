//
//  FlowEngineCareTaker.swift
//  FlowEngine_Example
//
//  Created by Diego Flores Domenech on 5/28/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import FlowEngine

class FlowEngineCareTaker {
    
    private struct FlowEngineMemento {
        let viewController: UIViewController
        let flowEngine: FlowEngine
    }
    
    private var mementos: [FlowEngineMemento] = []
    
    func saveFlowEngine(_ flowEngine: FlowEngine, for viewController: UIViewController) {
        let memento = FlowEngineMemento(viewController: viewController, flowEngine: flowEngine)
        self.mementos.append(memento)
    }
    
    func getFlowEngine(for viewController: UIViewController) -> FlowEngine? {
        return self.mementos.first(where: {$0.viewController == viewController})?.flowEngine
    }
}

//
//  FlowEngineBehaviour.swift
//  FlowEngine
//
//  Created by Diego Flores Domenech on 6/2/20.
//

import Foundation
import MLCommons

public class FlowEngineBehaviour : MLBaseBehaviour {
    
    private let snapshot: FlowEngineSnapshot
    private var wasPushed = false
    
    public init(flowEngine: FlowEngine) {
        self.snapshot = flowEngine.takeSnapshot()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        if wasPushed {
            let viewController = self.viewController as? FlowEngineComponent
            viewController?.flowEngine.reset(with: self.snapshot)
        }
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        guard let lastViewController = viewController.navigationController?.viewControllers.last else { return }
        if viewController != lastViewController, viewController.parent != lastViewController {
            self.wasPushed = true
        }
    }
    
}

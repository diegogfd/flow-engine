//
//  NavigationControllerDelegate.swift
//  FlowEngine_Example
//
//  Created by Diego Flores Domenech on 5/28/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import MLCommons
import FlowEngine

class NavigationControllerDelegate: NSObject, UINavigationControllerDelegate {
    
    private let careTaker = FlowEngineCareTaker()
    private var lastStack: [UIViewController] = []
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        guard var viewController = viewController as? UIViewController & FlowEngineComponent else {
            return
        }
        if lastStack.contains(viewController) {
            //is poping
            if let flowEngineMemento = self.careTaker.getFlowEngine(for: viewController) {
                //load memento
                viewController.flowEngine = flowEngineMemento
            }
        } else {
            //is pushing
            //save memento
            self.careTaker.saveFlowEngine(viewController.flowEngine, for: viewController)
        }
        self.lastStack = navigationController.viewControllers
    }
    
//    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
//        guard var viewController = viewController as? MLBaseViewController & FlowEngineComponent,
//        let behaviour = viewController.getBehaviour(FlowEngineBehaviour.self) as? FlowEngineBehaviour else {
//            return
//        }
//        viewController.flowEngine = behaviour.flowEngineMemento
//    }
}

//
//  NavigationAction.swift
//  FlowEngine_Example
//
//  Created by Diego Flores Domenech on 4/14/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import FlowEngine

protocol NavigationAction : Action {
    init(navigationController: UINavigationController)
}

//
//  NavigationAction.swift
//  FlowEngine
//
//  Created by Diego Flores Domenech on 4/1/20.
//  Copyright © 2020 Diego Flores. All rights reserved.
//

import Foundation
import UIKit

protocol NavigationAction : Action {
    init(navigationController: UINavigationController)
}

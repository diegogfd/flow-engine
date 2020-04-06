//
//  Rule.swift
//  FlowEngine
//
//  Created by Diego Flores Domenech on 3/29/20.
//  Copyright © 2020 Diego Flores. All rights reserved.
//

import Foundation

protocol Rule {
    func evaluate(value: Any?) -> ValidationError?
}

//
//  Optional+Nil.swift
//  FlowEngine
//
//  Created by Diego Flores Domenech on 6/2/20.
//

import Foundation

extension Optional {
    func isNil() -> Bool {
        switch self as Any {
        case Optional<Any>.none:
            return true
        default:
            return false
        }
    }
}

//
//  RuleEvaluatorBool.swift
//  FlowEngine
//
//  Created by Diego Flores Domenech on 5/19/20.
//

import Foundation

struct RuleEvaluatorBool : SimpleRuleEvaluator {
    
    typealias T = Bool
    
    func equals(left: T, right: T) -> Bool {
        return left == right
    }
    
    func distinct(left: T, right: T) -> Bool {
        return left != right
    }
    
}

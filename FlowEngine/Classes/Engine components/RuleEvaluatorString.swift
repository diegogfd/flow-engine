//
//  RuleEvaluatorString.swift
//  FlowEngine
//
//  Created by Diego Flores Domenech on 5/19/20.
//

import Foundation

struct RuleEvaluatorString : SimpleRuleEvaluator {
    
    typealias T = String
    
    func greaterThan(left: T, right: T) -> Bool {
        return left.count > right.count
    }
    
    func greaterThanOrEqual(left: T, right: T) -> Bool {
        return left.count >= right.count
    }
    
    func lessThan(left: T, right: T) -> Bool {
        return left.count < right.count
    }
    
    func lessThanOrEqual(left: T, right: T) -> Bool {
        return left.count <= right.count
    }
    
    func equals(left: T, right: T) -> Bool {
        return left == right
    }
    
    func distinct(left: T, right: T) -> Bool {
        return left != right
    }
    
}

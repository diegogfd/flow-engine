//
//  RuleEvaluatorDouble.swift
//  FlowEngine
//
//  Created by Diego Flores Domenech on 5/19/20.
//

import Foundation

struct RuleEvaluatorDouble : RuleEvaluatorImpl {
    
    typealias T = Double
    
    func greaterThan(left: T, right: T) -> Bool {
        return left > right
    }
    
    func greaterThanOrEqual(left: T, right: T) -> Bool {
        return left >= right
    }
    
    func lessThan(left: T, right: T) -> Bool {
        return left < right
    }
    
    func lessThanOrEqual(left: T, right: T) -> Bool {
        return left <= right
    }
    
    func equals(left: T, right: T) -> Bool {
        return left == right
    }
    
    func distinct(left: T, right: T) -> Bool {
        return left != right
    }
    
}

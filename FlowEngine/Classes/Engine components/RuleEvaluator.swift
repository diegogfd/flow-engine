//
//  RuleEvaluator.swift
//  FlowEngine
//
//  Created by Diego Flores Domenech on 5/19/20.
//

import Foundation

protocol RuleEvaluator {
    func evaluate(rule: Rule, value: Any?) -> Bool
}

protocol RuleEvaluatorImpl: RuleEvaluator {
    
    associatedtype T
        
    func greaterThan(left: T, right: T) -> Bool
    func greaterThanOrEqual(left: T, right: T) -> Bool
    func lessThan(left: T, right: T) -> Bool
    func lessThanOrEqual(left: T, right: T) -> Bool
    func equals(left: T, right: T) -> Bool
    func distinct(left: T, right: T) -> Bool
}

extension RuleEvaluatorImpl {
    
    func evaluate(rule: Rule, value: Any?) -> Bool {
        guard let ruleValue = rule.value as? T else {
            return false
        }
        if rule.type == .null {
            return value == nil
        } else if rule.type == .notNull {
            return value != nil
        }
        guard let value = value as? T else {
            return false
        }
        switch rule.type {
        case .greaterThan:
            return self.greaterThan(left: value, right: ruleValue)
        case .greaterThanOrEqual:
            return self.greaterThanOrEqual(left: value, right: ruleValue)
        case .lessThan:
            return self.lessThan(left: value, right: ruleValue)
        case .lessThanOrEqual:
            return self.lessThanOrEqual(left: value, right: ruleValue)
        case .equals:
            return self.equals(left: value, right: ruleValue)
        case .distinct:
            return self.distinct(left: value, right: ruleValue)
        default:
            return false
        }
    }
    
    func greaterThan(left: T, right: T) -> Bool {
        return false
    }
    
    func greaterThanOrEqual(left: T, right: T) -> Bool {
        return false
    }
    
    func lessThan(left: T, right: T) -> Bool {
        return false
    }
    
    func lessThanOrEqual(left: T, right: T) -> Bool {
        return false
    }
    
    func equals(left: T, right: T) -> Bool {
        return false
    }
    
    func distinct(left: T, right: T) -> Bool {
        return false
    }
    
}





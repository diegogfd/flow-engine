//
//  RuleEvaluator.swift
//  FlowEngine
//
//  Created by Diego Flores Domenech on 5/19/20.
//

import Foundation

protocol RuleEvaluator {
    func evaluate(rule: Rule, state: FlowState) -> Bool
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
    
    func evaluate(rule: Rule, state: FlowState) -> Bool {
        guard let fieldId = rule.fieldId, let ruleValue = rule.value as? T else {
            return false
        }
        if rule.type == .null {
            return state.getFieldValue(id: fieldId) == nil
        } else if rule.type == .notNull {
            return state.getFieldValue(id: fieldId) != nil
        }
        guard let stateValue = state.getFieldValue(id: fieldId) as? T else {
            return false
        }
        switch rule.type {
        case .greaterThan:
            return self.greaterThan(left: stateValue, right: ruleValue)
        case .greaterThanOrEqual:
            return self.greaterThanOrEqual(left: stateValue, right: ruleValue)
        case .lessThan:
            return self.lessThan(left: stateValue, right: ruleValue)
        case .lessThanOrEqual:
            return self.lessThanOrEqual(left: stateValue, right: ruleValue)
        case .equals:
            return self.equals(left: stateValue, right: ruleValue)
        case .distinct:
            return self.distinct(left: stateValue, right: ruleValue)
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





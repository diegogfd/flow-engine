//
//  RuleEvaluator.swift
//  FlowEngine
//
//  Created by Diego Flores Domenech on 5/19/20.
//

import Foundation

protocol RuleEvaluator {
    func evaluate(rule: Rule, value: Any?) -> Bool
    func evaluate(rule: Rule, state: FlowState) -> Bool
}

protocol SimpleRuleEvaluator: RuleEvaluator {
    
    associatedtype T
        
    func greaterThan(left: T, right: T) -> Bool
    func greaterThanOrEqual(left: T, right: T) -> Bool
    func lessThan(left: T, right: T) -> Bool
    func lessThanOrEqual(left: T, right: T) -> Bool
    func equals(left: T, right: T) -> Bool
    func distinct(left: T, right: T) -> Bool
}

extension SimpleRuleEvaluator {
    
    func evaluate(rule: Rule, value: Any?) -> Bool {
        guard let ruleValue = rule.value as? T else {
            return false
        }
        if rule.type == .null {
            return value == nil
        } else if rule.type == .notNull {
            return value != nil
        }
        // si el value es un enum, trato de obtener el rawValue
        let rawValueExtractor = RawValueExtractor()
        guard let value = value, let rawValue = rawValueExtractor.getRawValue(from: value) as? T else {
            return false
        }
        switch rule.type {
        case .greaterThan:
            return self.greaterThan(left: rawValue, right: ruleValue)
        case .greaterThanOrEqual:
            return self.greaterThanOrEqual(left: rawValue, right: ruleValue)
        case .lessThan:
            return self.lessThan(left: rawValue, right: ruleValue)
        case .lessThanOrEqual:
            return self.lessThanOrEqual(left: rawValue, right: ruleValue)
        case .equals:
            return self.equals(left: rawValue, right: ruleValue)
        case .distinct:
            return self.distinct(left: rawValue, right: ruleValue)
        default:
            return false
        }
    }
    
    func evaluate(rule: Rule, state: FlowState) -> Bool {
        guard let field = rule.field else {
            return false
        }
        let value = state.getFieldValue(id: field)
        return self.evaluate(rule: rule, value: value)
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





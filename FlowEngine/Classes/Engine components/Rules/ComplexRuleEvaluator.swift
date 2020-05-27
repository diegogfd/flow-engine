//
//  ComplexRuleEvaluator.swift
//  FlowEngine
//
//  Created by Diego Flores Domenech on 5/21/20.
//

import Foundation

struct ComplexRuleEvaluator : RuleEvaluator {
    
    func evaluate(rule: Rule, value: Any?) -> Bool {
        return rule.subRules?.reduce(true) { (accumulation: Bool, subRule: Rule) -> Bool in
            if rule.type == .and {
                return accumulation && subRule.evaluate(value: value)
            } else if rule.type == .or {
                return accumulation || subRule.evaluate(value: value)
            }
            return false
        } ?? false
    }
    
    func evaluate(rule: Rule, state: FlowState) -> Bool {
        return rule.subRules?.reduce(true) { (accumulation: Bool, subRule: Rule) -> Bool in
            if rule.type == .and {
                return accumulation && subRule.evaluate(state: state)
            } else if rule.type == .or {
                return accumulation || subRule.evaluate(state: state)
            }
            return false
        } ?? false
    }
}

//
//  ComplexRuleEvaluator.swift
//  FlowEngine
//
//  Created by Diego Flores Domenech on 5/21/20.
//

import Foundation

struct ComplexRuleEvaluator : RuleEvaluator {
    
    func evaluate(rule: Rule, value: Any?) -> Bool {
        return rule.subRules?.reduce(true) { (accumulation: Bool, nextValue: Rule) -> Bool in
            if rule.type == .and {
                return accumulation && nextValue.evaluate(value: value)
            } else if rule.type == .or {
                return accumulation || nextValue.evaluate(value: value)
            }
            return false
        } ?? false
    }
    
    
}

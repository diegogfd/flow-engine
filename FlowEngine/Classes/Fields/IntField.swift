//
//  IntField.swift
//  FlowEngine
//
//  Created by Diego Flores Domenech on 4/10/20.
//  Copyright © 2020 Diego Flores. All rights reserved.
//

import Foundation

struct IntField : Field {
    typealias T = Int
    
    var fieldData: FieldValidationData
    
    func greaterThan(fieldValue: T?, ruleValue: T?)  -> Result<Bool, RuleError> {
        guard let fieldValue = fieldValue, let ruleValue = ruleValue else {
            return .failure(.invalidData)
        }
        return fieldValue > ruleValue ? .success(true) : .failure(.notSatisfied(Rule(ruleType: .greaterThan, value: ruleValue)))
    }
    
    func greaterThanOrEqual(fieldValue: T?, ruleValue: T?) -> Result<Bool, RuleError> {
        guard let fieldValue = fieldValue, let ruleValue = ruleValue else {
            return .failure(.invalidData)
        }
        return fieldValue >= ruleValue ? .success(true) : .failure(.notSatisfied(Rule(ruleType: .greaterThanOrEqual, value: ruleValue)))
    }
    
    func lessThan(fieldValue: T?, ruleValue: T?) -> Result<Bool, RuleError> {
        guard let fieldValue = fieldValue, let ruleValue = ruleValue else {
            return .failure(.invalidData)
        }
        return fieldValue < ruleValue ? .success(true) : .failure(.notSatisfied(Rule(ruleType: .lessThan, value: ruleValue)))
    }
    
    func lessThanOrEqual(fieldValue: T?, ruleValue: T?) -> Result<Bool, RuleError> {
        guard let fieldValue = fieldValue, let ruleValue = ruleValue else {
            return .failure(.invalidData)
        }
        return fieldValue <= ruleValue ? .success(true) : .failure(.notSatisfied(Rule(ruleType: .lessThanOrEqual, value: ruleValue)))
    }
    
    func equals(fieldValue: T?, ruleValue: T?) -> Result<Bool, RuleError> {
        guard let fieldValue = fieldValue, let ruleValue = ruleValue else {
            return .failure(.invalidData)
        }
        return fieldValue == ruleValue ? .success(true) : .failure(.notSatisfied(Rule(ruleType: .equals, value: ruleValue)))
    }
    
    func distinct(fieldValue: T?, ruleValue: T?) -> Result<Bool, RuleError> {
        guard let fieldValue = fieldValue, let ruleValue = ruleValue else {
            return .failure(.invalidData)
        }
        return fieldValue != ruleValue ? .success(true) : .failure(.notSatisfied(Rule(ruleType: .distinct, value: ruleValue)))
    }
}

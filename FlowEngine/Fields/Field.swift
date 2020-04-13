//
//  Field.swift
//  FlowEngine
//
//  Created by Diego Flores Domenech on 4/10/20.
//  Copyright © 2020 Diego Flores. All rights reserved.
//

import Foundation

protocol Field {
    
    associatedtype T
    
    var fieldData: FieldValidationData { get }
    
    func greaterThan(fieldValue: T?, ruleValue: T?) -> Result<Bool, RuleError>
    func greaterThanOrEqual(fieldValue: T?, ruleValue: T?) -> Result<Bool, RuleError>
    func lessThan(fieldValue: T?, ruleValue: T?) -> Result<Bool, RuleError>
    func lessThanOrEqual(fieldValue: T?, ruleValue: T?) -> Result<Bool, RuleError>
    func equals(fieldValue: T?, ruleValue: T?) -> Result<Bool, RuleError>
    func distinct(fieldValue: T?, ruleValue: T?) -> Result<Bool, RuleError>
    
    func evaluateRules(fieldValue: T?) -> Result<Bool,FieldValidationError>
}

extension Field {
    
    func evaluateRules(fieldValue: T?) -> Result<Bool,FieldValidationError> {
        let rulesResults = self.fieldData.validations?.map({ (rule) -> Result<Bool, RuleError> in
            guard let ruleValue = rule.value as? T else {
                return .failure(.invalidData)
            }
            let result: Result<Bool, RuleError>
            switch rule.ruleType {
                case .equals:
                    result = self.equals(fieldValue: fieldValue, ruleValue: ruleValue)
                case .distinct:
                    result = self.distinct(fieldValue: fieldValue, ruleValue: ruleValue)
                case .greaterThan:
                    result = self.greaterThan(fieldValue: fieldValue, ruleValue: ruleValue)
                case .greaterThanOrEqual:
                    result = self.greaterThanOrEqual(fieldValue: fieldValue, ruleValue: ruleValue)
                case .lessThan:
                    result = self.lessThan(fieldValue: fieldValue, ruleValue: ruleValue)
                case .lessThanOrEqual:
                    result = self.lessThanOrEqual(fieldValue: fieldValue, ruleValue: ruleValue)
                default:
                    result = .failure(.invalidOperation)
            }
            return result
        })
        let errors = rulesResults?.compactMap({ (result) -> RuleError? in
            switch result {
            case .success(_):
                return nil
            case .failure(let error):
                return error
            }
        })
        if let errors = errors, !errors.isEmpty {
            return .failure(.ruleErrors(errors))
        }
        return .success(true)
    }
    
    func greaterThan(fieldValue: T?, ruleValue: T?) -> Result<Bool, RuleError> {
        return .failure(.invalidOperation)
    }
    
    func greaterThanOrEqual(fieldValue: T?, ruleValue: T?) -> Result<Bool, RuleError>{
        return .failure(.invalidOperation)
    }
    
    func lessThan(fieldValue: T?, ruleValue: T?) -> Result<Bool, RuleError>{
        return .failure(.invalidOperation)
    }
    
    func lessThanOrEqual(fieldValue: T?, ruleValue: T?) -> Result<Bool, RuleError>{
        return .failure(.invalidOperation)
    }
    
    func equals(fieldValue: T?, ruleValue: T?) -> Result<Bool, RuleError>{
        return .failure(.invalidOperation)
    }
    
    func distinct(fieldValue: T?, ruleValue: T?) -> Result<Bool, RuleError>{
        return .failure(.invalidOperation)
    }
    
}

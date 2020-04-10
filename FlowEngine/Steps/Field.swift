//
//  Field.swift
//  FlowEngine
//
//  Created by Diego Flores Domenech on 4/10/20.
//  Copyright © 2020 Diego Flores. All rights reserved.
//

import Foundation

enum FieldId: String, MirrorableEnum, CaseIterable {
    case amount = "AMOUNT"
    case descr = "DESCRIPTION"
    case installments = "INSTALLMENTS"
    case cardType = "CARD_TYPE"
}

enum FieldType: String {
    case integer
    case double
    case string
    case bool
}

enum FieldValidationError<T> : Error {
    case ruleErrors([RuleError<T>])
}

protocol Field {
    
    associatedtype T
    
    var fieldData: FieldValidationData { get }
    
    func greaterThan(fieldValue: T?, otherValue: T?) -> Result<Bool, RuleError<T>>
    func greaterThanOrEqual(fieldValue: T?, otherValue: T?) -> Result<Bool, RuleError<T>>
    func lessThan(fieldValue: T?, otherValue: T?) -> Result<Bool, RuleError<T>>
    func lessThanOrEqual(fieldValue: T?, otherValue: T?) -> Result<Bool, RuleError<T>>
    func equals(fieldValue: T?, otherValue: T?) -> Result<Bool, RuleError<T>>
    func distinct(fieldValue: T?, otherValue: T?) -> Result<Bool, RuleError<T>>
    
    func evaluateRules(fieldValue: T?) -> Result<Bool,FieldValidationError<T>>
}

extension Field {
    
    func evaluateRules(fieldValue: T?) -> Result<Bool,FieldValidationError<T>> {
        let rulesResults = self.fieldData.validations?.map({ (rule) -> Result<Bool, RuleError<T>> in
            guard let ruleValue = rule.value as? T else {
                return .failure(.invalidData)
            }
            let result: Result<Bool, RuleError<T>>
            switch rule.ruleType {
                case .equals:
                    result = self.equals(fieldValue: fieldValue, otherValue: ruleValue)
                case .distinct:
                    result = self.distinct(fieldValue: fieldValue, otherValue: ruleValue)
                case .greaterThan:
                    result = self.greaterThan(fieldValue: fieldValue, otherValue: ruleValue)
                case .greaterThanOrEqual:
                    result = self.greaterThanOrEqual(fieldValue: fieldValue, otherValue: ruleValue)
                case .lessThan:
                    result = self.lessThan(fieldValue: fieldValue, otherValue: ruleValue)
                case .lessThanOrEqual:
                    result = self.lessThanOrEqual(fieldValue: fieldValue, otherValue: ruleValue)
                default:
                    result = .failure(.invalidOperation)
            }
            return result
        })
        let errors = rulesResults?.compactMap({ (result) -> RuleError<Self.T>? in
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
    
    func greaterThan(fieldValue: T?, otherValue: T?) -> Result<Bool, RuleError<T>> {
        return .failure(.invalidOperation)
    }
    
    func greaterThanOrEqual(fieldValue: T?, otherValue: T?) -> Result<Bool, RuleError<T>>{
        return .failure(.invalidOperation)
    }
    
    func lessThan(fieldValue: T?, otherValue: T?) -> Result<Bool, RuleError<T>>{
        return .failure(.invalidOperation)
    }
    
    func lessThanOrEqual(fieldValue: T?, otherValue: T?) -> Result<Bool, RuleError<T>>{
        return .failure(.invalidOperation)
    }
    
    func equals(fieldValue: T?, otherValue: T?) -> Result<Bool, RuleError<T>>{
        return .failure(.invalidOperation)
    }
    
    func distinct(fieldValue: T?, otherValue: T?) -> Result<Bool, RuleError<T>>{
        return .failure(.invalidOperation)
    }
    
}

//
//  Field.swift
//  FlowEngine
//
//  Created by Diego Flores Domenech on 4/10/20.
//  Copyright © 2020 Diego Flores. All rights reserved.
//

import Foundation

enum FieldId: String {
    case amount = "AMOUNT"
    case description = "DESCRIPTION"
    case installments = "INSTALLMENTS"
    case cardType = "CARD_TYPE"
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
    func equal(fieldValue: T?, otherValue: T?) -> Result<Bool, RuleError<T>>
    
    func evaluateRules(fieldValue: T?) -> Result<Bool,FieldValidationError<T>>
}

extension Field {
    
    func evaluateRules(fieldValue: T?) -> Result<Bool,FieldValidationError<T>> {
        let rulesResults = self.fieldData.validations?.map({ (rule) -> Result<Bool, RuleError<T>> in
            guard let ruleValue = rule.value as? T else {
                return .failure(.mismatchData)
            }
            let result: Result<Bool, RuleError<T>>
            switch rule.ruleType {
                case .equals:
                    result = self.equal(fieldValue: fieldValue, otherValue: ruleValue)
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
    
}

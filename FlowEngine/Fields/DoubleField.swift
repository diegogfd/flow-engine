//
//  DoubleField.swift
//  FlowEngine
//
//  Created by Diego Flores Domenech on 4/10/20.
//  Copyright © 2020 Diego Flores. All rights reserved.
//

import Foundation

struct DoubleField: Field {
    
    typealias T = Double
    
    var fieldData: FieldValidationData
    
    func greaterThan(fieldValue: T?, otherValue: T?)  -> Result<Bool, RuleError<T>> {
        guard let fieldValue = fieldValue, let otherValue = otherValue else {
            return .failure(.invalidData)
        }
        return fieldValue > otherValue ? .success(true) : .failure(.notSatisfied(.greaterThan,fieldValue))
    }
    
    func greaterThanOrEqual(fieldValue: T?, otherValue: T?) -> Result<Bool, RuleError<T>> {
        guard let fieldValue = fieldValue, let otherValue = otherValue else {
            return .failure(.invalidData)
        }
        return fieldValue >= otherValue ? .success(true) : .failure(.notSatisfied(.greaterThanOrEqual,fieldValue))
    }
    
    func lessThan(fieldValue: T?, otherValue: T?) -> Result<Bool, RuleError<T>> {
        guard let fieldValue = fieldValue, let otherValue = otherValue else {
            return .failure(.invalidData)
        }
        return fieldValue < otherValue ? .success(true) : .failure(.notSatisfied(.lessThan,fieldValue))
    }
    
    func lessThanOrEqual(fieldValue: T?, otherValue: T?) -> Result<Bool, RuleError<T>> {
        guard let fieldValue = fieldValue, let otherValue = otherValue else {
            return .failure(.invalidData)
        }
        return fieldValue <= otherValue ? .success(true) : .failure(.notSatisfied(.lessThanOrEqual,fieldValue))
    }
    
    func equals(fieldValue: T?, otherValue: T?) -> Result<Bool, RuleError<T>> {
        guard let fieldValue = fieldValue, let otherValue = otherValue else {
            return .failure(.invalidData)
        }
        return fieldValue == otherValue ? .success(true) : .failure(.notSatisfied(.equals,fieldValue))
    }
    
    func distinct(fieldValue: T?, otherValue: T?) -> Result<Bool, RuleError<T>> {
        guard let fieldValue = fieldValue, let otherValue = otherValue else {
            return .failure(.invalidData)
        }
        return fieldValue != otherValue ? .success(true) : .failure(.notSatisfied(.distinct,fieldValue))
    }

}

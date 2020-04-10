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
    
    func greaterThan(fieldValue: T?, otherValue: T?)  -> Result<Bool, RuleError<T>> {
        return .success(true)
    }
    
    func greaterThanOrEqual(fieldValue: T?, otherValue: T?) -> Result<Bool, RuleError<T>> {
        return .success(true)
    }
    
    func lessThan(fieldValue: T?, otherValue: T?) -> Result<Bool, RuleError<T>> {
        return .success(true)
    }
    
    func lessThanOrEqual(fieldValue: T?, otherValue: T?) -> Result<Bool, RuleError<T>> {
        return .success(true)
    }
    
    func equal(fieldValue: T?, otherValue: T?) -> Result<Bool, RuleError<T>> {
        return .success(true)
    }
}

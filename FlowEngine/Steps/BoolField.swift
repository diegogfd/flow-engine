//
//  BoolField.swift
//  FlowEngine
//
//  Created by Diego Flores Domenech on 4/10/20.
//  Copyright © 2020 Diego Flores. All rights reserved.
//

import Foundation

struct BoolField: Field {
    
    typealias T = Bool

    var fieldData: FieldValidationData
    
    func equals(fieldValue: T?, otherValue: T?) -> Result<Bool, RuleError<T>> {
        return fieldValue == otherValue ? .success(true) : .failure(.notSatisfied(.equals,fieldValue))
    }
    
    func distinct(fieldValue: T?, otherValue: T?) -> Result<Bool, RuleError<T>> {
        return fieldValue != otherValue ? .success(true) : .failure(.notSatisfied(.distinct,fieldValue))
    }
    
}

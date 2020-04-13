//
//  StringField.swift
//  FlowEngine
//
//  Created by Diego Flores Domenech on 4/10/20.
//  Copyright © 2020 Diego Flores. All rights reserved.
//

import Foundation

struct StringField: Field {
    
    typealias T = String

    var fieldData: FieldValidationData
    
    func equals(fieldValue: T?, ruleValue: T?) -> Result<Bool, RuleError> {
        return fieldValue == ruleValue ? .success(true) : .failure(.notSatisfied(Rule(ruleType: .equals, value: ruleValue)))
    }
    
    func distinct(fieldValue: T?, ruleValue: T?) -> Result<Bool, RuleError> {
        return fieldValue != ruleValue ? .success(true) : .failure(.notSatisfied(Rule(ruleType: .distinct, value: ruleValue)))
    }
    
}

//
//  Step.swift
//  FlowEngine
//
//  Created by Diego Flores Domenech on 3/29/20.
//  Copyright © 2020 Diego Flores. All rights reserved.
//

import Foundation

class Step: FlowEngineComponent, Decodable {
    var flowEngine: FlowEngine!
    let id: String
    let requiredFields: [FieldValidationData]
    let optionalFields: [FieldValidationData]
    let enterRules: [FieldValidationData]
    
    private var fulfilledFields: [FieldValidationData] = []
    private var allFields: [FieldValidationData] {
        return self.requiredFields + self.optionalFields
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case requiredFields = "required_fields"
        case optionalFields = "optional_fields"
        case enterRules = "enter_rules"
    }
    
    private func fieldData(for id: FieldId) -> FieldValidationData? {
        return self.allFields.first(where: { $0.id == id})
    }
    
    func evaluateField(value: Int, fieldId: FieldId) -> Result<Bool,FieldValidationError<Int>> {
        guard let fieldData = self.fieldData(for: fieldId) else {
            return .failure(.ruleErrors([.invalidOperation]))
        }
        let field = IntField(fieldData: fieldData)
        return field.evaluateRules(fieldValue: value)
    }
}

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
    let requiredFields: [FieldId]
    let optionalFields: [FieldId]
    let enterRules: [FieldValidationData]
    
    enum CodingKeys: String, CodingKey {
        case id
        case requiredFields = "required_fields"
        case optionalFields = "optional_fields"
        case enterRules = "rules"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        let rawRequiredFields = try container.decode([String].self, forKey: .requiredFields)
        self.requiredFields = try rawRequiredFields.map { (rawField) -> FieldId in
            guard let field = FieldId(rawValue: rawField) else {
                throw DecodingError.typeMismatch(FieldId.self, DecodingError.Context(codingPath: container.codingPath, debugDescription: "Not a valid id"))
            }
            return field
        }
        let rawOptionalFields = try container.decode([String].self, forKey: .requiredFields)
        self.optionalFields = try rawOptionalFields.map { (rawField) -> FieldId in
            guard let field = FieldId(rawValue: rawField) else {
                throw DecodingError.typeMismatch(FieldId.self, DecodingError.Context(codingPath: container.codingPath, debugDescription: "Not a valid id"))
            }
            return field
        }
        self.enterRules = try container.decode([FieldValidationData].self, forKey: .enterRules)
    }
    
    var fulfilledFields: [FieldId] = [] {
        didSet {
            let requiredFieldsSet = Set(arrayLiteral: requiredFields)
            let fulfilledFieldsSet = Set(arrayLiteral: fulfilledFields)
            //chequeo si se completaron todos los campos para avanzar al next step
            if requiredFieldsSet.isSubset(of: fulfilledFieldsSet) {
                self.flowEngine.goToNextStep()
            }
        }
    }
    private var allFields: [FieldId] {
        return self.requiredFields + self.optionalFields
    }
    
    var canEnterToStep: Bool {
        for fieldData in self.enterRules {
            switch fieldData.type {
            case .integer:
                let field = IntField(fieldData: fieldData)
                let result = field.evaluateRules(fieldValue: self.flowEngine.state.getFieldValue(id: fieldData.id) as? Int)
                if case .failure(_) = result {
                    return false
                }
            case .string:
                let field = StringField(fieldData: fieldData)
                let result = field.evaluateRules(fieldValue: self.flowEngine.state.getFieldValue(id: fieldData.id) as? String)
                if case .failure(_) = result {
                    return false
                }
            case .double:
                let field = DoubleField(fieldData: fieldData)
                let result = field.evaluateRules(fieldValue: self.flowEngine.state.getFieldValue(id: fieldData.id) as? Double)
                if case .failure(_) = result {
                    return false
                }
            case .bool:
                let field = BoolField(fieldData: fieldData)
                let result = field.evaluateRules(fieldValue: self.flowEngine.state.getFieldValue(id: fieldData.id) as? Bool)
                if case .failure(_) = result {
                    return false
                }
            }
        }
        return true
    }
    
    private func fieldData(for id: FieldId) -> FieldValidationData? {
        return self.enterRules.first(where: { $0.id == id})
    }
    
    func evaluateField(fieldId: FieldId, value: RuleEvaluatable?) -> Result<Bool,FieldValidationError> {
        guard let fieldData = self.fieldData(for: fieldId) else {
            return .failure(.ruleErrors([.invalidOperation]))
        }
        if let value = value as? Int {
            let field = IntField(fieldData: fieldData)
            return field.evaluateRules(fieldValue: value)
        } else if let value = value as? Double {
            let field = DoubleField(fieldData: fieldData)
            return field.evaluateRules(fieldValue: value)
        } else if let value = value as? String {
            let field = StringField(fieldData: fieldData)
            return field.evaluateRules(fieldValue: value)
        } else if let value = value as? Bool {
            let field = BoolField(fieldData: fieldData)
            return field.evaluateRules(fieldValue: value)
        }
        return .failure(.ruleErrors([.invalidData]))
    }

    func fulfillField(fieldId: FieldId, value: RuleEvaluatable?) -> Result<Bool,FieldValidationError> {
        let result = self.evaluateField(fieldId: fieldId, value: value)
        switch result {
        case .success(_):
            self.flowEngine.state.setField(id: fieldId, value: value)
            self.fulfilledFields.append(fieldId)
            return .success(true)
        case .failure(let errors):
            return .failure(errors)
        }
    }
}

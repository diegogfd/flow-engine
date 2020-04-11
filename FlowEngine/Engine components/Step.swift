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
    
    var fulfilledFields: [FieldValidationData] = [] {
        didSet {
            let requiredFieldsSet = Set(arrayLiteral: requiredFields)
            let fulfilledFieldsSet = Set(arrayLiteral: fulfilledFields)
            //chequeo si se completaron todos los campos para avanzar al next step
            if requiredFieldsSet.isSubset(of: fulfilledFieldsSet) {
                self.flowEngine.goToNextStep()
            }
        }
    }
    private var allFields: [FieldValidationData] {
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
    
    enum CodingKeys: String, CodingKey {
        case id
        case requiredFields = "required_fields"
        case optionalFields = "optional_fields"
        case enterRules = "enter_rules"
    }
    
    private func fieldData(for id: FieldId) -> FieldValidationData? {
        return self.allFields.first(where: { $0.id == id})
    }
    
    //un metodo por cada tipo de dato
    func fulfillField(fieldId: FieldId, value: Int?) -> Result<Bool,FieldValidationError<Int>> {
        guard let fieldData = self.fieldData(for: fieldId) else {
            return .failure(.ruleErrors([.invalidOperation]))
        }
        let field = IntField(fieldData: fieldData)
        let result = field.evaluateRules(fieldValue: value)
        return self.evaluateResultAndSetState(fieldData: fieldData, value: value, result: result)
    }
    
    private func evaluateResultAndSetState(fieldData: FieldValidationData, value: Any?, result: Result<Bool,FieldValidationError<Int>>) -> Result<Bool,FieldValidationError<Int>> {
        switch result {
        case .success(_):
            self.flowEngine.state.setField(id: fieldData.id, value: value)
            self.fulfilledFields.append(fieldData)
            return .success(true)
        case .failure(let errors):
            return .failure(errors)
        }
    }
}

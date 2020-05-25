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
    let rule: Rule?
    
    var actions: [Action] = [] {
        didSet {
            self.currentAction = self.actions.first
        }
    }
    var currentAction: Action? {
        didSet {
            currentAction?.execute(for: self.allFields)
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case requiredFields = "required_fields"
        case optionalFields = "optional_fields"
        case rule = "rules"
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
        self.rule = try container.decode(Rule.self, forKey: .rule)
    }
    
    var fulfilledFields: [FieldId] = []
    
    var isFulfilled: Bool {
        let fulfilledFieldsSet = Set(arrayLiteral: self.fulfilledFields)
        let requiredFieldsSet = Set(arrayLiteral: self.requiredFields)
        return requiredFieldsSet.isSubset(of: fulfilledFieldsSet)
    }
    
    var allFields: [FieldId] {
        return self.requiredFields + self.optionalFields
    }
    
    var canEnterToStep: Bool {
        if let rule = rule {
            return rule.evaluate(state: self.flowEngine.state)
        }
        for field in requiredFields {
            let fieldValue = flowEngine.state.getFieldValue(id: field)
            if fieldValue == nil {
                return true
            }
        }
        return false
    }
    
    func executeNextAction() {
        self.actions.removeFirst()
        self.currentAction = self.actions.first
    }
    
}

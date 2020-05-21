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
    let rule: Rule
    
    var currentStepActions: [Action] = [] {
        didSet {
            self.currentAction = self.currentStepActions.first
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
    
    var fulfilledFields: [FieldId] = [] {
        didSet {
            guard let currentAction = self.currentAction else {
                return
            }
            let actionFieldsSet = Set(arrayLiteral: currentAction.fieldIds)
            let fulfilledFieldsSet = Set(arrayLiteral: self.fulfilledFields)
            if actionFieldsSet.isSubset(of: fulfilledFieldsSet) {
                //la accion ya completo todos sus campos
                self.currentStepActions.removeFirst()
                self.currentAction = self.currentStepActions.first
            }
            if self.currentAction == nil {
                //no tengo más acciones, deberia avanzar al next step
                self.flowEngine.goToNextStep()
            }
        }
    }
    
    var allFields: [FieldId] {
        return self.requiredFields + self.optionalFields
    }
    
    var canEnterToStep: Bool {
        return self.rule.evaluate(state: self.flowEngine.state)
    }
    
}

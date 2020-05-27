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
    
    var actions: [Action] = []
    
    var currentAction: Action? {
        didSet {
            guard let currentAction = currentAction else { return }
            let actionFieldsSet = Set(currentAction.fieldIds)
            let allFieldsSet = Set(self.allFields)
            let fieldsInCommon = Array(actionFieldsSet.intersection(allFieldsSet))
            currentAction.execute(for: fieldsInCommon)
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case requiredFields = "required_fields"
        case optionalFields = "optional_fields"
        case rule = "rules"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        let rawRequiredFields = try container.decode([String].self, forKey: .requiredFields)
        self.requiredFields = rawRequiredFields.map { (rawField) -> FieldId in
            return FieldId(rawValue: rawField) ?? .unknown
        }
        let rawOptionalFields = try container.decodeIfPresent([String].self, forKey: .optionalFields) ?? []
        self.optionalFields = rawOptionalFields.map { (rawField) -> FieldId in
            return FieldId(rawValue: rawField) ?? .unknown
        }
        self.rule = try container.decodeIfPresent(Rule.self, forKey: .rule)
    }
    
    var fulfilledFields: [FieldId] = []
    
    var isFulfilled: Bool {
        let fulfilledFieldsSet = Set(self.fulfilledFields)
        let requiredFieldsSet = Set(self.requiredFields)
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
            //TODO: resolver por qué nil != nil
            if fieldValue.debugDescription == "Optional(nil)"{
                return true
            }
//            if fieldValue == nil {
//                return true
//            }
        }
        return false
    }
    
    func executeNextAction() {
        let currentAction = self.actions.first
        self.actions.removeFirst()
        self.currentAction = currentAction
    }
    
}

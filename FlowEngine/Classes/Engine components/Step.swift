//
//  Step.swift
//  FlowEngine
//
//  Created by Diego Flores Domenech on 3/29/20.
//  Copyright © 2020 Diego Flores. All rights reserved.
//

import Foundation

struct Step : Decodable {
    let id: String
    let requiredFields: [FieldId]
    let optionalFields: [FieldId]
    let rule: Rule?
        
    private enum CodingKeys: String, CodingKey {
        case id
        case requiredFields = "required_fields"
        case optionalFields = "optional_fields"
        case rule = "rules"
    }
    
    init(from decoder: Decoder) throws {
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

    func isFulfilled(state: FlowState) -> Bool {
        let fulfilledFieldsSet = Set(state.fulfilledFields)
        let requiredFieldsSet = Set(self.requiredFields)
        return requiredFieldsSet.isSubset(of: fulfilledFieldsSet)
    }
    
    var allFields: [FieldId] {
        return self.requiredFields + self.optionalFields
    }
    
    func canEnterToStep(state: FlowState) -> Bool {
        var canEnter = false
        for field in requiredFields {
            let fieldValue = state.getFieldValue(id: field)
            if fieldValue.isNil() {
                canEnter = true
            }
        }
        if let rule = rule {
            return rule.evaluate(state: state) && canEnter
        }
        
        return canEnter
    }
}

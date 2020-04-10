//
//  FieldValidationData.swift
//  FlowEngine
//
//  Created by Diego Flores Domenech on 4/1/20.
//  Copyright © 2020 Diego Flores. All rights reserved.
//

import Foundation

struct FieldValidationData : Equatable, Hashable, Decodable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case validations
    }
    
    let id: FieldId
    let type: FieldType
    let validations: [Rule]?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let rawId = try container.decode(String.self, forKey: .id)
        guard let id = FieldId(rawValue: rawId) else {
            throw DecodingError.typeMismatch(FieldId.self, DecodingError.Context(codingPath: container.codingPath, debugDescription: "Not a valid id"))
        }
        self.id = id
        guard let type = FieldType(rawValue: rawId) else {
            throw DecodingError.typeMismatch(FieldType.self, DecodingError.Context(codingPath: container.codingPath, debugDescription: "Not a valid type"))
        }
        self.type = type
        self.validations = try container.decodeIfPresent([Rule].self, forKey: .validations)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: FieldValidationData, rhs: FieldValidationData) -> Bool {
        return lhs.id == rhs.id
    }
    
}

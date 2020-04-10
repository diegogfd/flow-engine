//
//  ActionRepresentation.swift
//  FlowEngine
//
//  Created by Diego Flores Domenech on 4/8/20.
//  Copyright © 2020 Diego Flores. All rights reserved.
//

import Foundation

struct ActionRepresentation : Decodable {
    let id: String
    let fieldIds: [FieldId]
    
    enum CodingKeys: String, CodingKey {
        case id
        case fields
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let rawFields = try container.decode([String].self, forKey: .fields)
        self.fieldIds = try rawFields.map { (rawField) -> FieldId in
            guard let field = FieldId(rawValue: rawField) else {
                throw DecodingError.typeMismatch(FieldId.self, DecodingError.Context(codingPath: container.codingPath, debugDescription: "Not a valid id"))
            }
            return field
        }
        self.id = try container.decode(String.self, forKey: .id)
    }
}

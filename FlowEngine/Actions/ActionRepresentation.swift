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
    let fieldIds: [Field.Id]
    
    enum CodingKeys: String, CodingKey {
        case id
        case fields
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let rawFields = try container.decode([String].self, forKey: .fields)
        self.fieldIds = try rawFields.map { (rawField) -> Field.Id in
            guard let field = Field.Id(rawValue: rawField) else {
                throw DecodingError.typeMismatch(Field.Id.self, DecodingError.Context(codingPath: container.codingPath, debugDescription: "Not a valid id"))
            }
            return field
        }
        self.id = try container.decode(String.self, forKey: .id)
    }
}

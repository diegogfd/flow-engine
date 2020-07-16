//
//  ActionRepresentation.swift
//  FlowEngine
//
//  Created by Diego Flores Domenech on 4/8/20.
//  Copyright © 2020 Diego Flores. All rights reserved.
//

import Foundation

struct ActionRepresentation : Decodable {
    let id: ActionId
    let fields: [Field]
    
    enum CodingKeys: String, CodingKey {
        case id
        case fields
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let rawFields = try container.decode([String].self, forKey: .fields)
        self.fields = rawFields.map { (rawField) -> Field in
            return Field(rawValue: rawField) ?? .unknown
        }
        let rawId = try container.decode(String.self, forKey: .id)
        self.id = ActionId(rawValue: rawId) ?? .unknown
    }
}

//
//  Rule.swift
//  FlowEngine
//
//  Created by Diego Flores Domenech on 3/29/20.
//  Copyright © 2020 Diego Flores. All rights reserved.
//

import Foundation

enum RuleError<T> : Error {
    case mismatchData
    case invalidOperation
    case notSatisfied(BooleanOperator, T)
}

enum BooleanOperator: String, Decodable {
    case equals
    case not
    case and
    case or
    case greaterThan
    case lessThan
    case greaterThanOrEqual
    case lessThanOrEqual
}

struct Rule: Decodable {
    
    let ruleType: BooleanOperator
    let value: JSONValue?
        
    enum CodingKeys: String, CodingKey {
        case ruleType
        case value
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.ruleType = try values.decode(BooleanOperator.self, forKey: .ruleType)
        self.value = try values.decode(JSONValue.self, forKey: .value)
    }
    
}

//
//  Rule.swift
//  FlowEngine
//
//  Created by Diego Flores Domenech on 3/29/20.
//  Copyright © 2020 Diego Flores. All rights reserved.
//

import Foundation

public enum RuleError : Error {
    case invalidData
    case invalidOperation
    case notSatisfied(Rule)
}

public enum BooleanOperator: String, Decodable {
    case equals
    case distinct
    case not
    case and
    case or
    case greaterThan
    case lessThan
    case greaterThanOrEqual
    case lessThanOrEqual
}

public struct Rule: Decodable {
    
    public let ruleType: BooleanOperator
    public let value: RuleEvaluatable?
        
    enum CodingKeys: String, CodingKey {
        case ruleType
        case value
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.ruleType = try values.decode(BooleanOperator.self, forKey: .ruleType)
        let jsonValue = try values.decode(JSONValue.self, forKey: .value)
        self.value = jsonValue.value as? RuleEvaluatable
    }
    
    init(ruleType: BooleanOperator, value: RuleEvaluatable?) {
        self.ruleType = ruleType
        self.value = value
    }
}

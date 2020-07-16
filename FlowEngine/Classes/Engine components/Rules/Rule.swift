//
//  Rule.swift
//  FlowEngine
//
//  Created by Diego Flores Domenech on 5/19/20.
//

import Foundation

struct Rule : Decodable {
    
    enum RuleType: String {
        case equals = "EQUALS"
        case distinct = "DISTINCT"
        case not = "NOT"
        case and = "AND"
        case or = "OR"
        case greaterThan = "GREATER_THAN"
        case lessThan = "LESS_THAN"
        case greaterThanOrEqual = "GREATER_THAN_OR_EQUAL"
        case lessThanOrEqual = "LESS_THAN_OR_EQUAL"
        case null = "NULL"
        case notNull = "NOT_NULL"
    }
    
    private enum CodingKeys: String, CodingKey {
        case type
        case field
        case valueType = "value_type"
        case jsonValue = "value"
        case subRules = "rule"
    }
    
    enum ValueType: String, Decodable {
        case integer
        case double
        case string
        case bool
    }
    
    let type: RuleType
    let field: Field?
    let valueType: ValueType?
    let subRules: [Rule]?
    private let jsonValue: JSONValue?
    var value: Any? {
        return jsonValue?.value
    }
    
    private var evaluator: RuleEvaluator {
        if let valueType = valueType {
            switch valueType {
            case .integer:
                return RuleEvaluatorInt()
            case .double:
                return RuleEvaluatorDouble()
            case .string:
                return RuleEvaluatorString()
            case .bool:
                return RuleEvaluatorBool()
            }
        } else {
            return ComplexRuleEvaluator()
        }
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.field = try values.decodeIfPresent(Field.self, forKey: .field)
        let rawType = try values.decode(String.self, forKey: .type)
        if let type = RuleType(rawValue: rawType) {
            self.type = type
        } else {
            throw DecodingError.typeMismatch(RuleType.self, DecodingError.Context(
            codingPath: [],
            debugDescription: "El tipo de rule es desconocido",
            underlyingError: nil))
        }
        self.valueType = try values.decodeIfPresent(ValueType.self, forKey: .valueType)
        self.jsonValue = try values.decodeIfPresent(JSONValue.self, forKey: .jsonValue)
        self.subRules = try values.decodeIfPresent([Rule].self, forKey: .subRules)
    }
    
    func evaluate(state: FlowState) -> Bool {
        return evaluator.evaluate(rule: self, state: state)
    }
    
    func evaluate(value: Any?) -> Bool {
        return evaluator.evaluate(rule: self, value: value)
    }
    
}

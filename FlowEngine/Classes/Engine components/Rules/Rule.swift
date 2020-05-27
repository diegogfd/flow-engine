//
//  Rule.swift
//  FlowEngine
//
//  Created by Diego Flores Domenech on 5/19/20.
//

import Foundation

struct Rule : Decodable {
    
    enum RuleType: String, Decodable {
        case equals
        case distinct
        case not
        case and
        case or
        case greaterThan = "greater_than"
        case lessThan = "less_than"
        case greaterThanOrEqual = "greater_than_or_equal"
        case lessThanOrEqual = "less_than_or_equal"
        case null
        case notNull
    }
    
    private enum CodingKeys: String, CodingKey {
        case type
        case fieldId = "field_id"
        case valueType = "value_type"
        case jsonValue = "value"
        case subRules = "sub_rules"
    }
    
    enum ValueType: String, Decodable {
        case integer
        case double
        case string
        case bool
    }
    
    let type: RuleType
    let fieldId: FieldId?
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
        self.fieldId = try values.decodeIfPresent(FieldId.self, forKey: .fieldId)
        self.type = try values.decode(RuleType.self, forKey: .type)
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
    
    func getFailingRules(value: Any?) -> [Rule]? {
        if let subRules = subRules {
            return subRules.filter({!$0.evaluate(value: value)})
        } else if !self.evaluate(value: value) {
            return [self]
        }
        return nil
    }
    
}

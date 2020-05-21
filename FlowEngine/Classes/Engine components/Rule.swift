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
        case greaterThan
        case lessThan
        case greaterThanOrEqual
        case lessThanOrEqual
        case null
        case notNull
    }
    
    enum CodingKeys: String, CodingKey {
        case type
        case fieldId = "field"
        case valueType = "value_type"
        case value
        case subRules = "rules"
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
    let value: Any?
    let subRules: [Rule]?
    
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
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.fieldId = try values.decode(FieldId.self, forKey: .fieldId)
        self.type = try values.decode(RuleType.self, forKey: .type)
        self.valueType = try values.decode(ValueType.self, forKey: .valueType)
        let jsonValue = try values.decode(JSONValue.self, forKey: .value)
        self.value = jsonValue.value
        self.subRules = try values.decode([Rule].self, forKey: .subRules)
    }
    
    func evaluate(state: FlowState) -> Bool {
        guard let fieldId = self.fieldId else {
            return false
        }
        let value = state.getFieldValue(id: fieldId)
        return self.evaluate(value: value)
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

//
//  Step.swift
//  FlowEngine
//
//  Created by Diego Flores Domenech on 3/29/20.
//  Copyright © 2020 Diego Flores. All rights reserved.
//

import Foundation

class Step: FlowEngineComponent, Equatable {
    let name: String
    let requiredFields: Set<Field>
    let optionalFields: Set<Field>?
    let rules: [Rule]?
    unowned var flowEngine: FlowEngine!
    
    private var fulfilledFields: Set<Field> = []
    
    private var isFulfilled: Bool {
        return self.requiredFields.isSubset(of: self.fulfilledFields)
    }
    
    init(name: String, requiredFields: Set<Field>, optionalFields: Set<Field>? = nil, rules: [Rule]? = nil) {
        self.name = name
        self.requiredFields = requiredFields
        self.optionalFields = optionalFields
        self.rules = rules
    }
    
    func fulfillField(name: Field.Name, value: Any?) -> Result<Bool,ValidationError> {
        //run validations
        guard let field = self.requiredFields.union(self.optionalFields ?? []).first(where: {$0.name == name}) else {
            return .failure(.genericError)
        }
        var errorResult: ValidationError?
        field.validations?.forEach({ (rule) in
            if let error = rule.evaluate(value: value) {
                errorResult = error
                return
            }
        })
        if errorResult == nil {
            self.fulfilledFields.insert(field)
        }
        if let errorResult = errorResult {
            return .failure(errorResult)
        }
        return .success(self.isFulfilled)
    }
    
    static func == (lhs: Step, rhs: Step) -> Bool {
        return lhs.name == rhs.name
    }
}

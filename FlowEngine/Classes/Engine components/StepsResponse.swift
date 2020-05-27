//
//  StepsResponse.swift
//  FlowEngine
//
//  Created by Diego Flores Domenech on 5/22/20.
//

import Foundation

enum OperationType: String, Decodable {
    case charge
    case presentialRefund = "presential_refund"
}

struct StepsResponse : Decodable {
    let steps: [Step]
    let validations: [FieldValidation]
    let operationType: OperationType
    
    private enum CodingKeys: String, CodingKey {
        case steps
        case validations
        case operationType = "operation_type"
    }
}

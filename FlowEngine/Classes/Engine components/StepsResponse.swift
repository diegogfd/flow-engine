//
//  StepsResponse.swift
//  FlowEngine
//
//  Created by Diego Flores Domenech on 5/22/20.
//

import Foundation

enum OperationType: String, Decodable {
    case payment
    case presentialRefund = "presential_refund"
}

struct StepsResponse : Decodable {
    let steps: [Step]
    let validations: [FieldValidation]
    let operationType: OperationType
}

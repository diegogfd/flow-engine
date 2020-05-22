//
//  FieldValidation.swift
//  FlowEngine
//
//  Created by Diego Flores Domenech on 5/19/20.
//

import Foundation

enum FieldValidationError : Error {
    case failed([FieldValidation])
}

public struct FieldValidation : Decodable {
    
    let id: String
    let fieldId: FieldId
    let rule: Rule
    
}

//
//  FieldValidation.swift
//  FlowEngine
//
//  Created by Diego Flores Domenech on 5/19/20.
//

import Foundation

public enum FieldValidationError : Error {
    case failed([FieldValidation])
}

public struct FieldValidation : Decodable {
    
    public let id: String
    let fieldId: FieldId
    let rule: Rule
    
}

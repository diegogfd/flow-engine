//
//  FieldEnums.swift
//  FlowEngine
//
//  Created by Diego Flores Domenech on 4/11/20.
//  Copyright © 2020 Diego Flores. All rights reserved.
//

import Foundation

enum FieldId: String, MirrorableEnum, CaseIterable {
    case amount = "AMOUNT"
    case descr = "DESCRIPTION"
    case installments = "INSTALLMENTS"
    case cardType = "CARD_TYPE"
}

enum FieldType: String {
    case integer
    case double
    case string
    case bool
}

enum FieldValidationError : Error {
    case ruleErrors([RuleError])
}

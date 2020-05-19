//
//  FieldEnums.swift
//  FlowEngine
//
//  Created by Diego Flores Domenech on 4/11/20.
//  Copyright © 2020 Diego Flores. All rights reserved.
//

import Foundation

public enum FieldId: String, MirrorableEnum, CaseIterable, Decodable {
    case amount = "AMOUNT"
    case descr = "DESCRIPTION"
    case installments = "INSTALLMENTS"
    case cardType = "CARD_TYPE"
}

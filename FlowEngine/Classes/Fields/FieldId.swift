//
//  FieldEnums.swift
//  FlowEngine
//
//  Created by Diego Flores Domenech on 4/11/20.
//  Copyright © 2020 Diego Flores. All rights reserved.
//

import Foundation

public enum FieldId: String, CaseIterable, Decodable {
    case amount
    case description
    case installments
    case cardType = "card_type"
    case showedPaymentResult = "showed_payment_result"
    case unknown
}

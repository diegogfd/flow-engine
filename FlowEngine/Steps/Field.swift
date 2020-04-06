//
//  Field.swift
//  FlowEngine
//
//  Created by Diego Flores Domenech on 4/1/20.
//  Copyright © 2020 Diego Flores. All rights reserved.
//

import Foundation

struct Field : Equatable, Hashable {
    enum Name: String {
        case setAmount
        case setDescription
        case selectInstallments
        case selectCardType
    }
    
    let name: Name
    let validations: [Rule]?
    
    static func == (lhs: Field, rhs: Field) -> Bool {
        lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

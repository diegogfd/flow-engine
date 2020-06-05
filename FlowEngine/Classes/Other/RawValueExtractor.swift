//
//  Any+RawValue.swift
//  Pods
//
//  Created by Diego Flores Domenech on 6/4/20.
//

import Foundation

class RawValueExtractor {
    func getRawValue(from object: Any) -> Any {
        if let object = object as? StringRawRepresentable {
            return object.stringRawValue
        } else if let object = object as? IntRawRepresentable {
            return object.intRawValue
        } else if let object = object as? DoubleRawRepresentable {
            return object.doubleRawValue
        } else if let object = object as? BoolRawRepresentable {
            return object.boolRawValue
        }
        return object
    }
}

protocol StringRawRepresentable {
    var stringRawValue: String { get }
}

extension StringRawRepresentable
where Self: RawRepresentable, Self.RawValue == String {
    var stringRawValue: String { return rawValue }
}

protocol IntRawRepresentable {
    var intRawValue: Int { get }
}

extension IntRawRepresentable
where Self: RawRepresentable, Self.RawValue == Int {
    var intRawValue: Int { return rawValue }
}

protocol DoubleRawRepresentable {
    var doubleRawValue: Double { get }
}

extension DoubleRawRepresentable
where Self: RawRepresentable, Self.RawValue == Double {
    var doubleRawValue: Double { return rawValue }
}

protocol BoolRawRepresentable {
    var boolRawValue: Bool { get }
}

extension BoolRawRepresentable
where Self: RawRepresentable, Self.RawValue == Bool {
    var boolRawValue: Bool { return rawValue }
}

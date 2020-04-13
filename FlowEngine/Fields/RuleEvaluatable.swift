//
//  RuleEvaluatable.swift
//  FlowEngine
//
//  Created by Diego Flores Domenech on 4/13/20.
//  Copyright © 2020 Diego Flores. All rights reserved.
//

import Foundation

protocol RuleEvaluatable {}

extension Int: RuleEvaluatable {}
extension Double: RuleEvaluatable {}
extension String: RuleEvaluatable {}
extension Bool: RuleEvaluatable {}

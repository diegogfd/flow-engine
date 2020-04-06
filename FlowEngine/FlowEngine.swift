//
//  FlowEngine.swift
//  FlowEngine
//
//  Created by Diego Flores Domenech on 3/29/20.
//  Copyright © 2020 Diego Flores. All rights reserved.
//

import Foundation

protocol FlowEngineComponent {
    var flowEngine: FlowEngine! { get set }
}

class FlowEngine {
    
    let steps: [Step]
    let actions: [Action]

    private var currentStep: Step {
        didSet {
            let bestAction = self.getBestAction()
            bestAction?.execute()
        }
    }
    
    init(steps: [Step], actions: [Action]) {
        self.steps = steps
        self.actions = actions
        self.currentStep = steps.first!
        self.steps.forEach({$0.flowEngine = self})
        self.actions.forEach({
            var action = $0
            action.flowEngine = self
        })
    }
    
    private func getBestAction() -> Action? {
        //el que matchee mas campos gana
        let requiredFieldNames = self.currentStep.requiredFields.map({$0.name})
        let matchingFieldsPerAction = self.actions.map { (action) -> Int in
            return action.fields.filter({requiredFieldNames.contains($0.name)}).count
        }
        let maxOcurrences = matchingFieldsPerAction.max() ?? 0
        var bestActions: [Action] = []
        for (index, value) in matchingFieldsPerAction.enumerated() {
            if value == maxOcurrences {
                bestActions.append(self.actions[index])
            }
        }
        if bestActions.count > 1{
            //si hay empate se toma el que sume mas entre las prioridades
            let matchingFields = bestActions.map { (action) -> [ActionField] in
                return action.fields.filter({requiredFieldNames.contains($0.name)})
            }
            let results = matchingFields.map { (actionFields) -> Int in
                return actionFields.reduce(0) {sum, field in
                    return sum + field.priority.rawValue
                }
            }
            let maxResult = results.max() ?? 0
            for (index, value) in results.enumerated() {
                if value == maxResult {
                    return bestActions[index]
                }
            }
            return nil
        } else {
            return bestActions.first
        }
    }
    
    func fulfillField(name: Field.Name, value: Any?) -> ValidationError? {
        let result = self.currentStep.fulfillField(name: name, value: value)
        switch result {
        case .success(let goToNextStep):
            if goToNextStep {
                guard let index = self.steps.firstIndex(of: self.currentStep),
                    index + 1 < self.steps.count else {
                        return .genericError
                }
                self.currentStep = self.steps[index + 1]
            }
        case .failure(let error):
            return error
        }
        return nil
    }
}

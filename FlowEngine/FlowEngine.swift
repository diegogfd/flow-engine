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
    let activeActions: [ActionRepresentation]
    let state: FlowState

    var currentStep: Step! {
        didSet {
            let bestActionIds = self.getBestActionIds()
            self.currentStepActions = self.actions.filter({bestActionIds.contains($0.id)})
            self.currentAction = self.currentStepActions.first
        }
    }
    var currentStepActions: [Action] = []
    var currentAction: Action? {
        didSet {
            currentAction?.execute()
        }
    }
    
    init(steps: [Step], activeActions: [ActionRepresentation], actions: [Action], state: FlowState) {
        self.steps = steps
        self.actions = actions
        self.activeActions = activeActions
        self.state = state
        self.steps.forEach({$0.flowEngine = self})
        self.actions.forEach({
            var action = $0
            action.flowEngine = self
        })
        self.goToNextStep()
    }
    
    func goToNextStep() {
        if let nextStep = self.steps.first(where: {$0.canEnterToStep}) {
            self.currentStep = nextStep
        }
    }
    
    func goToNextActionIfNeeded() {
        guard let currentAction = self.currentAction else {
            return
        }
        let currentActionFields = Set(arrayLiteral: currentAction.fieldIds)
        let currentStepFulfilledFields = Set(arrayLiteral: currentStep.fulfilledFields.map({$0.id}))
        if currentActionFields.isSubset(of: currentStepFulfilledFields) {
            self.currentStepActions.removeFirst()
            self.currentAction = self.currentStepActions.first
        }
    }
    
    private func getBestActionIds() -> [ActionId] {
        var requiredFieldIds = self.currentStep.requiredFields.map({ return $0.id })
        var optionalFieldIds = self.currentStep.optionalFields.map({ return $0.id })
        var bestActions: [ActionRepresentation] = []
        while let fieldId = requiredFieldIds.first {
            var candidateActions = self.activeActions.filter({$0.fieldIds.contains(fieldId)})
            //filtro las que tengan más campos requeridos
            candidateActions = self.filterCandidateActions(candidateActions, by: requiredFieldIds)
            //filtro las que tengan más campos opcionales
            candidateActions = self.filterCandidateActions(candidateActions, by: optionalFieldIds)
            //filtro las que tengan menos de otros fields
            candidateActions = self.filterCandidateActions(candidateActions, byDistinct: requiredFieldIds + optionalFieldIds)
            if let selectedAction = candidateActions.first {
                bestActions.append(selectedAction)
                requiredFieldIds.removeAll(where: {selectedAction.fieldIds.contains($0)})
                optionalFieldIds.removeAll(where: {selectedAction.fieldIds.contains($0)})
            } else {
                // no deberia entrar acá, porque sino nunca vas a poder salir del step
                requiredFieldIds.removeAll(where: {$0 == fieldId})
            }
        }
        return bestActions.map({$0.id})
    }
    
    private func filterCandidateActions(_ candidateActions: [ActionRepresentation], by fields: [FieldId]) -> [ActionRepresentation]  {
        var candidateActions = candidateActions
        let requiredFieldsSatisfied = candidateActions.compactMap({$0.fieldIds.filter({fields.contains($0)}).count})
        for (index, numberOfFields) in requiredFieldsSatisfied.enumerated() {
            if numberOfFields != requiredFieldsSatisfied.max() {
                candidateActions.remove(at: index)
            }
        }
        return candidateActions
    }
    
    private func filterCandidateActions(_ candidateActions: [ActionRepresentation], byDistinct fields: [FieldId]) -> [ActionRepresentation]  {
        var candidateActions = candidateActions
        let requiredFieldsSatisfied = candidateActions.compactMap({$0.fieldIds.filter({!fields.contains($0)}).count})
        for (index, numberOfFields) in requiredFieldsSatisfied.enumerated() {
            if numberOfFields != requiredFieldsSatisfied.min() {
                candidateActions.remove(at: index)
            }
        }
        return candidateActions
    }
}

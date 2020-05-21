//
//  FlowEngine.swift
//  FlowEngine
//
//  Created by Diego Flores Domenech on 3/29/20.
//  Copyright © 2020 Diego Flores. All rights reserved.
//

import Foundation

public protocol FlowEngineComponent {
    var flowEngine: FlowEngine! { get set }
}

public class FlowEngine {
    
    private let steps: [Step]
    private let actions: [Action]
    private let activeActions: [ActionRepresentation]
    private let validations: [FieldValidation] = []
    let state: FlowState = FlowState()

    var currentStep: Step! {
        didSet {
            let bestActionIds = self.getBestActionIds()
            self.currentStep?.currentStepActions = self.actions.filter({bestActionIds.contains($0.id)})
        }
    }
    
    public init(stepsJSONData: Data, actionsJSONData: Data, actions: [Action]) {
        let jsonDecoder = JSONDecoder()
        self.steps = try! jsonDecoder.decode([Step].self, from: stepsJSONData)
        self.activeActions = try! jsonDecoder.decode([ActionRepresentation].self, from: actionsJSONData)
        self.actions = actions
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
    
    @discardableResult
    func updateFlowState(attributes: [Attribute]) -> Result<Void,FieldValidationError> {
        let result = self.validateAttributes(attributes: attributes)
        if case .success(()) = result {
            self.state.setAttributes(attributes)
            self.currentStep.fulfilledFields.append(contentsOf: attributes.map({$0.fieldId}))
        }
        return result
    }
    
    @discardableResult
    func updateFlowState(fieldId: FieldId, value: Any?) -> Result<Void,FieldValidationError> {
        return self.updateFlowState(attributes: [Attribute(fieldId: fieldId, value: value)])
    }
    
    func validateAttributes(attributes: [Attribute]) -> Result<Void,FieldValidationError> {
        var failedValidations: [FieldValidation] = []
        for attribute in attributes {
            let validationsForField = self.validations.filter({ $0.fieldId == attribute.fieldId})
            for validation in validationsForField {
                let result = validation.rule.evaluate(value: attribute.value)
                if !result{
                    failedValidations.append(validation)
                }
            }
        }
        if failedValidations.isEmpty {
            return .success(())
        }
        return .failure(.failed(failedValidations))
    }
    
    private func getBestActionIds() -> [ActionId] {
        var requiredFieldIds = self.currentStep.requiredFields
        var optionalFieldIds = self.currentStep.optionalFields
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
        //si quedan campos opcionales, repito el procedimiento, pueden no cumplirse todos
        while let fieldId = optionalFieldIds.first {
            var candidateActions = self.activeActions.filter({$0.fieldIds.contains(fieldId)})
            //filtro las que tengan más campos opcionales
            candidateActions = self.filterCandidateActions(candidateActions, by: optionalFieldIds)
            //filtro las que tengan menos de otros fields
            candidateActions = self.filterCandidateActions(candidateActions, byDistinct: optionalFieldIds)
            if let selectedAction = candidateActions.first {
                bestActions.append(selectedAction)
                optionalFieldIds.removeAll(where: {selectedAction.fieldIds.contains($0)})
            } else {
                optionalFieldIds.removeAll(where: {$0 == fieldId})
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

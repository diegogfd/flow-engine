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
    
    private var steps: [Step] = []
    private var actions: [Action] = []
    private var activeActions: [ActionRepresentation] = []
    private var validations: [FieldValidation] = []
    let state: FlowState = FlowState()
    
    public init() {
        
    }

    var currentStep: Step! {
        didSet {
            let actionIds = self.getActionIds()
            self.currentStep?.actions = self.actions.filter({actionIds.contains($0.id)})
            self.currentStep.executeNextAction()
        }
    }
    
    public func registerActions(_ actions: [Action]) {
        self.actions.append(contentsOf: actions)
        actions.forEach({
            var action = $0
            action.flowEngine = self
        })
    }
    
    public func registerAction(_ action: Action) {
        self.registerActions([action])
    }
    
    public func fetch(actionsFileName: String) {
        guard let stepsFile = Bundle.main.url(forResource: "steps", withExtension: "json"), let actionsFile = Bundle.main.url(forResource: actionsFileName, withExtension: "json") else {
            return
        }

        do {
            let stepsData = try Data(contentsOf: stepsFile)
            let stepsResponse = try JSONDecoder().decode(StepsResponse.self, from: stepsData)
            self.steps = stepsResponse.steps
            self.steps.forEach({$0.flowEngine = self})
            self.validations = stepsResponse.validations
            
            let actionsData = try Data(contentsOf: actionsFile)
            self.activeActions = try JSONDecoder().decode([ActionRepresentation].self, from: actionsData)
            self.currentStep = self.steps.first
        } catch {
            print("Bad JSON format")
        }
    }
    
    @discardableResult
    public func updateFlowState(attributes: [Attribute]) -> Result<Void,FieldValidationError> {
        let result = self.validateAttributes(attributes: attributes)
        if case .success(()) = result {
            self.state.setAttributes(attributes)
            self.currentStep.fulfilledFields.append(contentsOf: attributes.map({$0.fieldId}))
        }
        return result
    }
    
    @discardableResult
    public func updateFlowState(fieldId: FieldId, value: Any?) -> Result<Void,FieldValidationError> {
        return self.updateFlowState(attributes: [Attribute(fieldId: fieldId, value: value)])
    }
    
    public func validateAttributes(attributes: [Attribute]) -> Result<Void,FieldValidationError> {
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
    
    public func goNext() {
        if self.currentStep.isFulfilled, self.currentStep.actions.isEmpty {
            self.goToNextStep()
        } else {
            guard let currentAction = self.currentStep.currentAction else {
                return
            }
            //antes de salir de la acción, vuelvo a verificar que haya seteado todos los campos requeridos
            let currentActionRequiredFields = self.currentStep.requiredFields.filter({ currentAction.fieldIds.contains($0)})
            if currentActionRequiredFields.isEmpty {
                self.currentStep.executeNextAction()
            } else {
                let actionFieldsSet = Set(currentActionRequiredFields)
                let fulfilledFieldsSet = Set(self.currentStep.fulfilledFields)
                if actionFieldsSet.isSubset(of: fulfilledFieldsSet) {
                    self.currentStep.executeNextAction()
                }
            }
        }
    }
    
    private func goToNextStep() {
        if let nextStep = self.steps.first(where: {$0.canEnterToStep}) {
            self.currentStep = nextStep
        }
    }
    
    private func getActionIds() -> [ActionId] {
        self.activeActions.filter { (action) -> Bool in
            for fieldId in action.fields {
                if self.currentStep.allFields.contains(fieldId) {
                    return true
                }
            }
            return false
        }.map({$0.id})
    }
}

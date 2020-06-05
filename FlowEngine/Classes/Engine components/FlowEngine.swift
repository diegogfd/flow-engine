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
    private var currentStep: Step!
    private var actionsForCurrentStep: [Action] = []
    private var currentAction: Action?
    private var currentActionRepresentation: ActionRepresentation? {
        return self.activeActions.first(where: {$0.id == self.currentAction?.id})
    }
    
    public var state: FlowState = FlowState()
        
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
    
    public init() {
        
    }
    
    public func fetch(actionsFileName: String) {
        guard let stepsFile = Bundle.main.url(forResource: "steps", withExtension: "json"), let actionsFile = Bundle.main.url(forResource: actionsFileName, withExtension: "json") else {
            return
        }
        do {
            let stepsData = try Data(contentsOf: stepsFile)
            let stepsResponse = try JSONDecoder().decode(StepsResponse.self, from: stepsData)
            let actionsData = try Data(contentsOf: actionsFile)
            self.activeActions = try JSONDecoder().decode([ActionRepresentation].self, from: actionsData)
            self.state = FlowState()
            self.steps = stepsResponse.steps
            self.validations = stepsResponse.validations
            self.reset()
        } catch {
            print("Bad JSON format")
        }
    }
    
    @discardableResult
    public func updateFlowState(attributes: [Attribute]) -> Result<Void,FieldValidationError> {
        let result = self.validateAttributes(attributes: attributes)
        if case .success(()) = result {
            self.state.setAttributes(attributes)
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
        if let currentActionRepresentation = self.currentActionRepresentation {
            //verifico que la accion actual ya cubrió todos los campos requeridos
            let currentActionRequiredFields = currentActionRepresentation.fields.filter({self.currentStep.requiredFields.contains($0)})
            if currentActionRequiredFields.isEmpty {
                //la acción solo cubre campos opcionales, puedo salir de la acción
                self.goToNextStepOrAction()
            } else {
                let actionFieldsSet = Set(currentActionRequiredFields)
                let fulfilledFieldsSet = Set(self.state.fulfilledFields)
                if actionFieldsSet.isSubset(of: fulfilledFieldsSet) {
                    //los campos requeridos de la acción ya fueron cubiertos, puedo salir de la acción
                    self.goToNextStepOrAction()
                }
            }
        } else {
            self.goToNextStepOrAction()
        }
    }
    
    private func goToNextStepOrAction() {
        if actionsForCurrentStep.isEmpty {
            self.goToNextStep()
        } else {
            self.goToNextAction()
        }
    }
    
    private func goToNextStep() {
        self.currentStep = steps.first(where: {$0.canEnterToStep(state: state)})
        let actionIds = self.getActionIds(for: self.currentStep)
        self.actionsForCurrentStep = self.actions.filter({actionIds.contains($0.id)})
        self.goToNextAction()
    }
    
    private func goToNextAction() {
        guard !self.actionsForCurrentStep.isEmpty else { return }
        self.currentAction = self.actionsForCurrentStep.removeFirst()
        let actionFieldsSet = Set(self.currentActionRepresentation!.fields)
        let allFieldsSet = Set(self.currentStep.allFields)
        let fieldsInCommon = Array(actionFieldsSet.intersection(allFieldsSet))
        self.currentAction?.execute(for: fieldsInCommon)
    }
    
    private func getActionIds(for step: Step) -> [ActionId] {
        self.activeActions.filter { (action) -> Bool in
            for fieldId in action.fields {
                if step.allFields.contains(fieldId) {
                    return true
                }
            }
            return false
        }.map({$0.id})
    }
    
    func reset(with snapshot: FlowEngineSnapshot) {
        self.currentAction = snapshot.currentAction
        self.currentStep = snapshot.currentStep
        self.actionsForCurrentStep = snapshot.actionsForCurrentStep
        self.state = snapshot.state
    }
    
    func takeSnapshot() -> FlowEngineSnapshot{
        return FlowEngineSnapshot(currentStep: self.currentStep, currentAction: self.currentAction, actionsForCurrentStep: self.actionsForCurrentStep, state: self.state)
    }
    
    func reset() {
        self.currentStep = nil
        self.currentAction = nil
        self.actionsForCurrentStep = []
        self.state = FlowState()
    }
}

struct FlowEngineSnapshot {
    let currentStep: Step
    let currentAction: Action?
    let actionsForCurrentStep: [Action]
    let state: FlowState
}

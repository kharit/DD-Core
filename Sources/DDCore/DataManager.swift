//
//  DataManager.swift
//  
//
//  Created by Vasiliy Kharitonov on 27.07.2020.
//
// High level data management. Will call text processing from here (indirectly)

import Foundation

// MODEL within MVVM
public struct DataManager {
    
    var dataCollection: DataCollection {
        dataSource.dataCollection
    }
    public var displayData: DataCollection
    private var dataSource: DataSource
        
    public mutating func rebuildDisplayData(solution currentSolutionID: Solution.DDID, tag currentTagID: Tag.DDID,  process currentProcessID: DDProcess.DDID, flow currentFlowID: Flow.DDID, step currentStepID: Step.DDID)  {
        
        var displayProcesses = dataCollection.processes
        var displayFlows = dataCollection.flows
        var displaySteps = dataCollection.steps
        var displayTechSteps = dataCollection.techSteps
        
        if currentSolutionID != "" {
            let solution = dataCollection.solutions.first(where: { $0.id == currentSolutionID })!
            displayProcesses = displayProcesses.compactMap({(process: DDProcess) -> DDProcess? in
                if solution.processes.contains(process.id) {
                    return process
                } else {
                    return nil
                }
            })
            displayProcesses.sort(by: { $0.name < $1.name } )
        }
        
        if currentTagID != "" {
            let tag = dataCollection.tags.first(where: { $0.id == currentTagID })!
            displayProcesses = displayProcesses.compactMap({(process: DDProcess) -> DDProcess? in
                if process.relevantTags.contains(tag.id) {
                    return process
                } else {
                    return nil
                }
            })
            displayProcesses.sort(by: { $0.name < $1.name } )
        }
        
        if currentProcessID != "" {
            let process = dataCollection.processes.first(where: { $0.id == currentProcessID })!
            // Is the current process among the displayed?
            if displayProcesses.contains(process) {
                displayFlows = displayFlows.compactMap({(flow: Flow) -> Flow? in
                    if process.flows.contains(flow.id) {
                        return flow
                    } else {
                        return nil
                    }
                })
                displayFlows.sort(by: { $0.name < $1.name } )
            } else {
                // The current process is for another solution or tag, drop all the flows
                displayFlows = [Flow]()
            }
        }
        
        if currentFlowID != "" {
            let flow = dataCollection.flows.first(where: { $0.id == currentFlowID })!
            // Is the current flow among the displayed?
            if displayFlows.contains(flow) {
                var flowSteps = [Step]()
                for stepID in flow.steps {
                    flowSteps.append(displaySteps.first(where: { $0.id == stepID })!)
                }
                displaySteps = flowSteps
            } else {
                // The current flow is for another solution or tag or process, drop all the steps
                displaySteps = [Step]()
            }
        }
        
        if currentStepID != "" {
            let step = dataCollection.steps.first(where: { $0.id == currentStepID })!
            // Is the current step among the displayed?
            if displaySteps.contains(step) {
                displayTechSteps = displayTechSteps.compactMap({(techStep: TechStep) -> TechStep? in
                    if step.techSteps.contains(techStep.id) {
                        return techStep
                    } else {
                        return nil
                    }
                })
            } else {
                // The current step is for another solution or tag or process or flow, drop all the technical steps
                displayTechSteps = [TechStep]()
            }
        }
        
        displayData.processes = displayProcesses
        displayData.flows = displayFlows
        displayData.steps = displaySteps
        displayData.techSteps = displayTechSteps
    }
    
    public mutating func saveStep(_ step: Step) {
        dataSource.updateStep(step)
        let index = displayData.steps.firstIndex(where: { $0.id == step.id })!
        displayData.steps[index] = step
    }
    
    public mutating func addStep(_ step: Step, to flowID: Flow.DDID, before beforeStep: Step?) {
        let flow = dataCollection.flows.first(where: { $0.id == flowID })!
        
        // update the data
        dataSource.addStep(step, to: flow, before: beforeStep)
        
        // update the views
        let flowIndex = displayData.flows.firstIndex(where: { $0.id == flow.id })!
        if let beforeStep = beforeStep {
            let index = displayData.steps.firstIndex(where: { $0.id == beforeStep.id })!
            displayData.steps.insert(step, at: index)
            
            displayData.flows[flowIndex].steps.insert(step.id, at: index)
        } else {
            displayData.steps.append(step)
            
            displayData.flows[flowIndex]    .steps.append(step.id)
        }
    }
    
    public mutating func addSystem(_ system: System) {
        
        // update the data
        dataSource.addSystem(system)

        
        // update the views
        displayData.systems.append(system)
    }
    
    init(dataSource: DataSource) {
        self.dataSource = dataSource
        self.displayData = dataSource.dataCollection
    }
}

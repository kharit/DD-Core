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
    
    var dataCollection: DataCollection   // source data
    public var displayData: DataCollection
    var dataSource: DataSource
        
    public mutating func rebuildDisplayData(solution currentSolution: Solution?, tag currentTag: Tag?,  process currentProcess: DDProcess?, flow currentFlow: Flow?, step currentStep: Step?)  {
        
        var displayProcesses = dataCollection.processes
        var displayFlows = dataCollection.flows
        var displaySteps = dataCollection.steps
        var displayTechSteps = dataCollection.techSteps
        
        if let solution = currentSolution {
            displayProcesses = displayProcesses.compactMap({(process: DDProcess) -> DDProcess? in
                if solution.processes.contains(process.id) {
                    return process
                } else {
                    return nil
                }
            })
        }
        
        if let tag = currentTag {
            displayProcesses = displayProcesses.compactMap({(process: DDProcess) -> DDProcess? in
                if process.relevantTags.contains(tag.id) {
                    return process
                } else {
                    return nil
                }
            })
        }
        
        if let process = currentProcess {
            displayFlows = displayFlows.compactMap({(flow: Flow) -> Flow? in
                if process.flows.contains(flow.id) {
                    return flow
                } else {
                    return nil
                }
            })
        }
        
        if let flow = currentFlow {
            displaySteps = displaySteps.compactMap({(step: Step) -> Step? in
                if flow.steps.contains(step.id) {
                    return step
                } else {
                    return nil
                }
            })
        }
        
        if let step = currentStep {
            displayTechSteps = displayTechSteps.compactMap({(techStep: TechStep) -> TechStep? in
                if step.techSteps.contains(techStep.id) {
                    return techStep
                } else {
                    return nil
                }
            })
        }
        
        displayData.processes = displayProcesses
        displayData.flows = displayFlows
        displayData.steps = displaySteps
        displayData.techSteps = displayTechSteps
    }
    
    init(dataCollection: DataCollection, dataSource: DataSource) {
        self.dataCollection = dataCollection
        self.displayData = dataCollection
        self.dataSource = dataSource
    }
}

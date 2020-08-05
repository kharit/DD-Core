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
    
    public mutating func updateStep(_ step: Step) {
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
    
    public mutating func addResponsible(_ responsible: Responsible) {
        // update the data
        dataSource.addResponsible(responsible)

        // update the views
        displayData.responsibles.append(responsible)
    }
    
    public mutating func updateSystem(_ system: System) {
        dataSource.updateSystem(system)
        let index = displayData.systems.firstIndex(where: { $0.id == system.id })!
        displayData.systems[index] = system
    }
    
    public mutating func updateSolution(_ solution: Solution) {
        dataSource.updateSolution(solution)
        let index = displayData.solutions.firstIndex(where: { $0.id == solution.id })!
        displayData.solutions[index] = solution
    }
    
    func defineObjectsAttachedToSingleSolution<T>(_ solution: Solution) -> [T] where T: DDCoreData {
        var theObjects = [T]()
        
        return theObjects
    }
    
    mutating func removeFromDisplay<T>(_ object: T) where T: DDCoreData {
        // TODO: update all link?!?
        if let solution = object as? Solution {
            let index = displayData.solutions.firstIndex(where: { $0.id == solution.id })!
            displayData.solutions.remove(at: index)
        } else if let tag = object as? Tag {
            let index = displayData.tags.firstIndex(where: { $0.id == tag.id })!
            displayData.tags.remove(at: index)
        } else if let process = object as? DDProcess {
            let index = displayData.processes.firstIndex(where: { $0.id == process.id })!
            displayData.processes.remove(at: index)
        } else if let flow = object as? Flow {
            let index = displayData.flows.firstIndex(where: { $0.id == flow.id })!
            displayData.flows.remove(at: index)
        } else if let step = object as? Step {
            let index = displayData.steps.firstIndex(where: { $0.id == step.id })!
            displayData.steps.remove(at: index)
        } else if let techStep = object as? TechStep {
            let index = displayData.techSteps.firstIndex(where: { $0.id == techStep.id })!
            displayData.techSteps.remove(at: index)
        } else if let responsible = object as? Responsible {
            let index = displayData.responsibles.firstIndex(where: { $0.id == responsible.id })!
            displayData.responsibles.remove(at: index)
        } else if let system = object as? System {
            let index = displayData.systems.firstIndex(where: { $0.id == system.id })!
            displayData.systems.remove(at: index)
        } else {
            print("E: Didn't find a correct data type to remove from data collection")
        }
    }
    
    public mutating func deleteSolution(_ solution: Solution) {
//        let objectsToDelete = defineObjectsAttachedToSingleSolution(solution)
//        for object in objectsToDelete {
//            dataSource.delete(object)
//            removeFromDisplay(object)
//        }
        dataSource.delete(solution)
        removeFromDisplay(solution)
    }
    
    init(dataSource: DataSource) {
        self.dataSource = dataSource
        self.displayData = dataSource.dataCollection
    }
}

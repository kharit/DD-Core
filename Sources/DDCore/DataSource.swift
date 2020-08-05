//
//  DataSource.swift
//  
//
//  Created by Vasiliy Kharitonov on 28.07.2020.
//

import Foundation

struct DataSource {
    var type: DataSourceType = .None
    var dataCollection = DataCollection.createEmpty()
    var fileManager = DDFileManager()
    var projectName: String = ""
    
    mutating func updateStep(_ step: Step) {
        switch type {
        case .None:
            print("I: Just testing, nothing to update")
        case .LocalJSON:
            do {
                try fileManager.changeStep(step, dataSourceType: .LocalJSON)
            } catch {
                print(error)
            }
        }
        let index = dataCollection.steps.firstIndex(where: { $0.id == step.id })!
        dataCollection.steps[index] = step
        
    }
    
    mutating func updateSystem(_ system: System) {
        switch type {
        case .None:
            print("I: Just testing, nothing to update")
        case .LocalJSON:
            do {
                try fileManager.changeSystem(system, dataSourceType: .LocalJSON)
            } catch {
                print(error)
            }
        }
        let index = dataCollection.systems.firstIndex(where: { $0.id == system.id })!
        dataCollection.systems[index] = system
    }
    
    mutating func updateSolution(_ solution: Solution) {
        switch type {
        case .None:
            print("I: Just testing, nothing to update")
        case .LocalJSON:
            do {
                try fileManager.changeSolution(solution, dataSourceType: .LocalJSON)
            } catch {
                print(error)
            }
        }
        let index = dataCollection.solutions.firstIndex(where: { $0.id == solution.id })!
        dataCollection.solutions[index] = solution
    }
    
    mutating func addStep(_ step: Step, to flow: Flow, before beforeStep: Step?) {
        
        // add step id to the flow
        let flowIndex = dataCollection.flows.firstIndex(where: { $0.id == flow.id })!
        var flow = dataCollection.flows[flowIndex]
        
        if let beforeStep = beforeStep {
            let index = flow.steps.firstIndex(of: beforeStep.id)!
            flow.steps.insert(step.id, at: index)
        } else {
            flow.steps.append(step.id)
        }
        
        switch type {
        case .None:
            print("I: Just testing, nothing to update")
        case .LocalJSON:
            do {
                try fileManager.changeStep(step, dataSourceType: .LocalJSON)
                try fileManager.changeFlow(flow, dataSourceType: .LocalJSON)
            } catch {
                print(error)
            }
        }
        
        dataCollection.steps.append(step)
        dataCollection.flows[flowIndex] = flow

    }
    
    mutating func addSystem(_ system: System) {
        
        switch type {
        case .None:
            print("I: Just testing, nothing to update")
        case .LocalJSON:
            do {
                try fileManager.changeSystem(system, dataSourceType: .LocalJSON)
            } catch {
                print(error)
            }
        }
        
        dataCollection.systems.append(system)
    }
    
    mutating func addResponsible(_ responsible: Responsible) {
        
        switch type {
        case .None:
            print("I: Just testing, nothing to update")
        case .LocalJSON:
            do {
                try fileManager.changeResponsible(responsible, dataSourceType: .LocalJSON)
            } catch {
                print(error)
            }
        }
        
        dataCollection.responsibles.append(responsible)
    }
    
    mutating func removeFromCollection<T>(_ object: T) where T: DDCoreData {
        // TODO: update all link?!?
        if let solution = object as? Solution {
            let index = dataCollection.solutions.firstIndex(where: { $0.id == solution.id })!
            dataCollection.solutions.remove(at: index)
        } else if let tag = object as? Tag {
            let index = dataCollection.tags.firstIndex(where: { $0.id == tag.id })!
            dataCollection.tags.remove(at: index)
        } else if let process = object as? DDProcess {
            let index = dataCollection.processes.firstIndex(where: { $0.id == process.id })!
            dataCollection.processes.remove(at: index)
        } else if let flow = object as? Flow {
            let index = dataCollection.flows.firstIndex(where: { $0.id == flow.id })!
            dataCollection.flows.remove(at: index)
        } else if let step = object as? Step {
            let index = dataCollection.steps.firstIndex(where: { $0.id == step.id })!
            dataCollection.steps.remove(at: index)
        } else if let techStep = object as? TechStep {
            let index = dataCollection.techSteps.firstIndex(where: { $0.id == techStep.id })!
            dataCollection.techSteps.remove(at: index)
        } else if let responsible = object as? Responsible {
            let index = dataCollection.responsibles.firstIndex(where: { $0.id == responsible.id })!
            dataCollection.responsibles.remove(at: index)
        } else if let system = object as? System {
            let index = dataCollection.systems.firstIndex(where: { $0.id == system.id })!
            dataCollection.systems.remove(at: index)
        } else {
            print("E: Didn't find a correct data type to remove from data collection")
        }
    }
    
    mutating func delete<T>(_ object: T) where T: DDCoreData {
        
        switch type {
        case .None:
            print("I: Just testing, nothing to update")
        case .LocalJSON:
            do {
                try fileManager.delete(object, dataSourceType: .LocalJSON)
            } catch {
                print(error)
            }
        }
        
        removeFromCollection(object)
        
    }
    
    static func initFromData(dataCollection: DataCollection) -> DataSource {
        var dataSource = DataSource()
        dataSource.dataCollection = dataCollection
        return dataSource
    }
    
    static func initProject(projectName: String) -> DataSource {
        var dataSource = DataSource()
        do {
            (dataSource.type, dataSource.dataCollection) = try dataSource.fileManager.initData(projectName: projectName)
        } catch {
            print(error)
        }
        return dataSource
    }
}

enum DataSourceType {
    case None   // for testing purposes
    case LocalJSON
//    case RemoteGitMD
//    case API    // will come much later
}

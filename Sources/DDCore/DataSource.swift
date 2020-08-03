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

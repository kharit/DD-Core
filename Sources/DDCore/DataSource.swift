//
//  DataSource.swift
//  
//
//  Created by Vasiliy Kharitonov on 28.07.2020.
//

import Foundation

struct DataSource {
    let type: DataSourceType
    // let link: URL
    var dataCollection: DataCollection 
    
    mutating func updateStep(_ step: Step) {
        switch type {
        case .None:
            let index = dataCollection.steps.firstIndex(where: { $0.id == step.id })!
            dataCollection.steps[index] = step
        }
        
    }
    
    mutating func addStep(_ step: Step, to flow: Flow, before beforeStep: Step?) {
        switch type {
        case .None:
            // add the step
            dataCollection.steps.append(step)
            
            // add step id to the flow
            let flowIndex = dataCollection.flows.firstIndex(where: { $0.id == flow.id })!
            if let beforeStep = beforeStep {
                let index = dataCollection.flows[flowIndex].steps.firstIndex(of: beforeStep.id)!
                dataCollection.flows[flowIndex].steps.insert(step.id, at: index)
            } else {
                dataCollection.flows[flowIndex].steps.append(step.id)
            }
        }
    }
}

enum DataSourceType {
    case None   // for testing purposes
//    case LocalMD
//    case LocalJSON
//    case RemoteGitMD
//    case RemoteGitJSON  // simpler one
//    case API    // will come much later
}

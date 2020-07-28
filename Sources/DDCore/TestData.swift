//
//  TestData.swift
//  
//
//  Created by Vasiliy Kharitonov on 27.07.2020.
//

import Foundation

public extension DataManager {
    
    static func initWithTestData() -> DataManager {
        return DataManager(dataCollection: DataCollection(
            solutions: [
                Solution(id: "ERP01", name: ["EN":"ERP 01"], processes: ["21"]),
                Solution(id: "WMS01", name: ["EN":"EWM 01"], processes: ["22"]),
            ],
            tags: [
                Tag(id: "1", name: ["EN":"Global"]),
                Tag(id: "2", name: ["EN":"Kharit EU"]),
                Tag(id: "3", name: ["EN":"Kharit US"]),
            ],
            processes: [
                DDProcess(id: "21", name: ["EN": "Goods receipt from truck"], flows: [String](), relevantTags: [String](), description: ["EN": "Goods receipt from truck description"]),
                DDProcess(id: "22", name: ["EN": "Goods issue to truck"], flows: [String](), relevantTags: [String](), description: ["EN": "Goods issue to truck description"]),
            ],
            flows: [
                Flow(id: "31", name: ["EN": "Direct loading"], steps: [String](), description: ["EN": "Test description for direct loading"]),
                Flow(id: "32", name: ["EN": "Loading with staging"], steps: [String](), description: ["EN": "Test description for loading with staging"]),
                Flow(id: "33", name: ["EN": "Unloading with staging"], steps: [String](), description: ["EN": "Test description for unloading with staging"]),
                Flow(id: "34", name: ["EN": "Direct unloading"], steps: [String](), description: ["EN": "Test description for direct unloading"]),
            ],
            steps: [
                Step(id: "41", name: ["EN": "Create picking tasks"], stepType: StepType.Manual.rawValue, description: ["EN": "User goes to the transaction for creating picking tasks, finds a delivery using some number. Then press the buttom Create picking tasks"], responsible: "51", systems: ["61"], techSteps: [], umSteps: []),
                Step(id: "42", name: ["EN": "Execute picking tasks"], stepType: StepType.Manual.rawValue, description: ["EN": "User logs in to RF envirment and receive the tasks from the system. He follows instruction of screen and executes the tasks."], responsible: "51", systems: ["61"], techSteps: [], umSteps: []),
                Step(id: "43", name: ["EN": "Goods issue"], stepType: StepType.Automatic.rawValue, description: ["EN": "Goods issue is executed automatically upon finishing pickig/loading"], responsible: "51", systems: ["61"], techSteps: [], umSteps: []),
            ],
            techSteps: [
                TechStep(id: "71", name: ["EN": "Source bin determination"], description: ["EN": "test description of source bin determination"]),
                TechStep(id: "72", name: ["EN": "Handover area relevance"], description: ["EN": "test description of Handover area relevance"]),
                TechStep(id: "73", name: ["EN": "Direct loading relevance"], description: ["EN": "test description of Direct loading relevance"]),
            ],
            responsibles: [
                Responsible(id: "51", name: ["EN": "Warehouse administrator"])
            ],
            systems: [
                System(id: "61", name: ["EN": "SAP ERP"])
            ]
        ))
    }
}

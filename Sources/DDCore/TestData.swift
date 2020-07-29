//
//  TestData.swift
//  
//
//  Created by Vasiliy Kharitonov on 27.07.2020.
//

import Foundation

public extension DataManager {
    
    static func initWithTestData() -> DataManager {
        return DataManager(
            dataCollection: DataCollection(
                solutions: [
                    Solution(id: "ERP01", name: "ERP 01", processes: ["21"]),
                    Solution(id: "WMS01", name: "EWM 01", processes: ["22"]),
                ],
                tags: [
                    Tag(id: "1", name: "Global"),
                    Tag(id: "2", name: "Kharit EU"),
                    Tag(id: "3", name: "Kharit US"),
                ],
                processes: [
                    DDProcess(id: "21", name: "Goods receipt from truck", flows: ["33", "34"], relevantTags: ["1", "2", "3"], description: "Goods receipt from truck description"),
                    DDProcess(id: "22", name: "Goods issue to truck", flows: ["31", "32"], relevantTags: ["1"], description: "Goods issue to truck description"),
                ],
                flows: [
                    Flow(id: "31", name: "Direct loading", steps: ["44", "45", "41", "42", "43", "46"], description: "Test description for direct loading"),
                    Flow(id: "32", name: "Loading with staging", steps: [String](), description: "Test description for loading with staging"),
                    Flow(id: "33", name: "Unloading with staging", steps: [String](), description: "Test description for unloading with staging"),
                    Flow(id: "34", name: "Direct unloading", steps: [String](), description: "Test description for direct unloading"),
                ],
                steps: [
                    Step(id: "44", name: "Check in the truck", stepType: StepType.Manual.rawValue, description: "User goes to the transaction for check in, finds a truck using some number. Then presses the buttom Check in", responsible: "51", systems: ["61"], techSteps: [], umSteps: []),
                    Step(id: "45", name: "Move truck to a dock", stepType: StepType.Manual.rawValue, description: "User goes to the transaction for movements, finds a truck using some number. Then chooses the dock and presses the button move to a dock", responsible: "51", systems: ["61"], techSteps: [], umSteps: []),
                    Step(id: "41", name: "Create picking tasks", stepType: StepType.Manual.rawValue, description: "User goes to the transaction for creating picking tasks, finds a delivery using some number. Then presses the button Create picking tasks", responsible: "51", systems: ["61"], techSteps: ["71", "72", "73"], umSteps: []),
                    Step(id: "42", name: "Execute picking tasks", stepType: StepType.Manual.rawValue, description: "User logs in to RF envirment and receive the tasks from the system. He follows instruction of screen and executes the tasks.", responsible: "51", systems: ["61"], techSteps: [], umSteps: []),
                    Step(id: "43", name: "Goods issue", stepType: StepType.Automatic.rawValue, description: "Goods issue is executed automatically upon finishing pickig/loading", responsible: "51", systems: ["61"], techSteps: [], umSteps: []),
                    Step(id: "46", name: "Moving truck to a parking lot", stepType: StepType.Automatic.rawValue, description: "Upon goods issue track is automatically moved to a parking lot", responsible: "51", systems: ["61"], techSteps: [], umSteps: []),
                ],
                techSteps: [
                    TechStep(id: "71", name: "Source bin determination", description: "test description of source bin determination"),
                    TechStep(id: "72", name: "Handover area relevance", description: "test description of Handover area relevance"),
                    TechStep(id: "73", name: "Direct loading relevance", description: "test description of Direct loading relevance"),
                ],
                responsibles: [
                    Responsible(id: "51", name: "Warehouse administrator"),
                    Responsible(id: "52", name: "FLT Driver"),
                    Responsible(id: "53", name: "Warehouse manager"),
                    Responsible(id: "54", name: "Security")
                ],
                systems: [
                    System(id: "61", name: "SAP ERP")
                ]
            ),
            dataSource: DataSource(type: .None)
        )
    }
}

//
//  data.swift
//
//
//  Created by Vasiliy Kharitonov on 23.03.2020.
//

import Foundation

public struct DataCollection {
    public var solutions: [Solution]
    public var tags: [Tag]
    public var processes: [DDProcess]
    public var flows: [Flow]
    public var steps: [Step]
    public var techSteps: [TechStep]
    public var responsibles: [Responsible]
    public var systems: [System]
    //TODO: other data
    
    static func createEmpty() -> DataCollection {
        return DataCollection(solutions: [Solution](), tags: [Tag](), processes: [DDProcess](), flows: [Flow](), steps: [Step](), techSteps: [TechStep](), responsibles: [Responsible](), systems: [System]())
    }
    
//    static func create(solutions: [Solution], tags: [Tag], processes : [DDProcess], flows: [Flow], steps: [Step], techSteps: [TechStep]) -> DataCollection {
//        return DataCollection(solutions: solutions, tags: tags, processes: processes, flows: flows, steps: steps, techSteps: techSteps, responsibles: responsibles) // public initializer (free initializer is not available externally)
//    }
}

func generateID() -> String {
  let letters = "abcdef0123456789"
  return String((0..<32).map{ _ in letters.randomElement()! })
}

public enum Language: String {
    case EN
    case RU
    case IT
    case ES
    case HR
    case SK
}

public enum Group: String {
    case Administrators
    case OpCo
    case Consultants
    case Approvers
}

public enum StepType: String {
    case Manual
    case Automatic
    case OutOfSystem
    // decision points might be done later
}

public struct System: DDCoreData {
    public let id: DDID
    public var name: String
    
    public static func create() -> System {
        System(
            id: generateID(),
            name: ""
        )
    }
}

// declaration here, extensions in dataProcessing.swift
public protocol DDCoreData : Codable & Identifiable & Equatable {
    typealias DDID = String   // Just an alias for looks, althouth might make it a real type in the future
    var id: DDID { get }  // id is obligatory for any data
}

public struct Responsible : DDCoreData {
    public let id: DDID
    public var name: String
}

// a user of the system
public struct User : DDCoreData {
    public let id: DDID
    public var defaultTag: Tag.DDID
    public var groups: [String]    // [Group]
}

// an organisation for which a step is relevant, e.g. US or Germany
public struct Tag : DDCoreData {
    public let id: DDID
    public var name: String
}

// business process step, e.g. Loading or Picking
public struct Step : DDCoreData {
    public let id: DDID
    public var name: String
    public var stepType: String    // StepType
    public var description: String
    public var responsible: Responsible.DDID
    public var systems : [System.DDID]  // [System]
    public var techSteps: [TechStep.DDID]
    public var umSteps: [UMStep.DDID]
    
    public static func create() -> Step {
        Step(
            id: generateID(),
            name: "", stepType: StepType.Manual.rawValue,
            description: "",
            responsible: "",
            systems: [],
            techSteps: [],
            umSteps: [])
    }
}

// separate flow, e.g. Goods receipt from Supplier
public struct Flow : DDCoreData {
    public let id: DDID
    public var name: String
    public var steps: [Step.DDID]
    public var description: String
}

public struct Solution: DDCoreData {
    public let id: DDID
    public var name: String
    public var processes: [DDProcess.DDID]
}

// business process, e.g. Goods receipt from Truck
public struct DDProcess : DDCoreData {
    public let id: DDID
    public var name: String
    public var flows: [Flow.DDID]
    public var relevantTags: [Tag.DDID]
    public var description: String
}

// will be done after MVP
public struct ScriptStep : DDCoreData {
    public let id: DDID
    public var name: String
    // TODO: finish
}

// just a template, will be done after MVP
public struct Script : DDCoreData {
    public let id: DDID
    public var name: String
    public var scriptSteps: [ScriptStep.DDID]
    public var relevantTags: [Tag.DDID]
}

// just a template, will be done after MVP
public struct UMStep : DDCoreData {
    public let id: DDID
    public var name: String
    public var transaction: String
    public var description: String
}

// just a template, will be done after MVP
public struct UserManual : DDCoreData {
    public let id: DDID
    public var name: String
    public var umSteps: [UMStep.DDID]
}

// represents a separate technical process step, e.g. destination bin determination
public struct TechStep : DDCoreData {
    public let id: DDID
    public var name: String
    public var description: String
}

//
//  data.swift
//
//
//  Created by Vasiliy Kharitonov on 23.03.2020.
//

import Foundation

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
    public var name: [String: String]  // [Language: String]
}

// declaration here, extensions in dataProcessing.swift
public protocol DDCoreData : Codable & Identifiable {
    typealias DDID = String   // Just an alias for looks, althouth might make it a real type in the future
    var id: DDID { get }  // id is obligatory for any data
}

public struct Responsible : DDCoreData {
    public let id: DDID
    public var name: [String: String]  // [Language: String]
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
    public var name: [String: String]  // [Language: String]
    public init (id: DDID, name: [String: String]) {
        self.id = id
        self.name = name
    }
}

// business process step, e.g. Loading or Picking
public struct Step : DDCoreData {
    public let id: DDID
    public var name: [String: String]  // [Language: String]
    public var stepType: String    // StepType
    public var description: [String: String]   // [Language: String]
    public var responsible: Responsible.DDID
    public var systems : [System.DDID]  // [System]
    public var bpSteps: [BPStep.DDID]
    public var umSteps: [UMStep.DDID]
}

// separate flow, e.g. Goods receipt from Supplier
public struct Flow : DDCoreData {
    public let id: DDID
    public var name: [String: String]  // [Language: String]
    public var steps: [Step.DDID]
    public var description: [String: String]   // [Language: String]
    public init(id: DDID, name: [String: String], steps: [Step.DDID], description: [String: String]) {
        self.id = id
        self.name = name
        self.steps = steps
        self.description = description
    }
}

public struct Solution: DDCoreData {
    public let id: DDID
    public var name: [String: String]  // [Language: String]
    public var businessProcesses: [BusinessProcess.DDID]
    public init (id: DDID, name: [String: String], businessProcesses: [BusinessProcess.DDID]) {
        self.id = id
        self.name = name
        self.businessProcesses = businessProcesses
    }
}

// business process, e.g. Goods receipt from Truck
public struct BusinessProcess : DDCoreData {
    public let id: DDID
    public var name: [String: String]  // [Language: String]
    public var flows: [Flow.DDID]
    public var relevantTags: [Tag.DDID]
    public var description: [String: String]   // [Language: String]
    public init(id: DDID, name: [String: String], flows: [Flow.DDID], relevantTags: [Tag.DDID], description: [String: String]) {
        self.id = id
        self.name = name
        self.flows = flows
        self.relevantTags = relevantTags
        self.description = description
    }
}

// will be done after MVP
public struct ScriptStep : DDCoreData {
    public let id: DDID
    public var name: [String: String]  // [Language: String]
    // TODO: finish
}

// just a template, will be done after MVP
public struct Script : DDCoreData {
    public let id: DDID
    public var name: [String: String]  // [Language: String]
    public var scriptSteps: [ScriptStep.DDID]
    public var relevantTags: [Tag.DDID]
}

// just a template, will be done after MVP
public struct UMStep : DDCoreData {
    public let id: DDID
    public var name: [String: String]  // [Language: String]
    public var transaction: String
    public var description: [String: String]   // [Language: String]
}

// just a template, will be done after MVP
public struct UserManual : DDCoreData {
    public let id: DDID
    public var name: [String: String]  // [Language: String]
    public var umSteps: [UMStep.DDID]
}

// represents a separate Business process step, e.g. task creation
public struct BPStep : DDCoreData {
    public let id: DDID
    public var name: [String: String]  // [Language: String]
    public var isGlobal: Bool
    public var relevantTags: [Tag.DDID]
    public var description: [String: String]   // [Language: String]
}
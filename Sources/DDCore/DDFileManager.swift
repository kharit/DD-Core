//
//  DDFileManager.swift
//  
//
//  Created by Vasiliy Kharitonov on 02.08.2020.
//

import Foundation

struct DDFileManager {
    let fileManager = FileManager.default
    let appDirectory = "~/.dd/"
    var workingDirectory = ""
    let jsonDecoder = JSONDecoder()
    let jsonEncoder = JSONEncoder()
    
    init() {
        do {
            try initDirectory()
        } catch {
            print(error)
        }
        
    }
    
    func initDirectory() throws {
        print("I: The current home directory is \(NSHomeDirectory())")
        if (try? fileManager.contentsOfDirectory(atPath: appDirectory)) != nil {
            print("I: App directory \(appDirectory) already exists")
        } else {
            try fileManager.createDirectory(atPath: appDirectory, withIntermediateDirectories: true)
            print("I: Working directory \(appDirectory) is successfully created")
        }
    }
    
    // insane function that returns a function that returns an array of a customType
    func readData<T>(dataSourceType: DataSourceType, dataType: T.Type, folderName: String) throws -> [T] where T: DDCoreData {
        var returnArray = [T]()
        if let folderContents = try? self.fileManager.contentsOfDirectory(atPath: "\(self.workingDirectory)\(folderName)/") {
            for elementID in folderContents {
                if let elementFile = self.fileManager.contents(atPath: self.workingDirectory + "\(folderName)/\(elementID)") {
                    switch dataSourceType {
                    case .LocalJSON:
                        let element = try self.jsonDecoder.decode(dataType, from: elementFile)
                        returnArray.append(element)
                    default:
                        print("E: dataSourceType is incorrect")
                    }
                }
            }
        }
        return returnArray
    }
    
    func delete<T>(_ object: T, dataSourceType: DataSourceType) throws where T: DDCoreData {
        
        var folderName = ""
        var fileName = ""
        
        if let solution = object as? Solution {
            folderName = "solutions/"
            fileName = solution.id
        } else if let tag = object as? Tag {
            folderName = "tags/"
            fileName = tag.id
        } else if let process = object as? DDProcess {
            folderName = "processes/"
            fileName = process.id
        } else if let flow = object as? Flow {
            folderName = "flows/"
            fileName = flow.id
        } else if let step = object as? Step {
            folderName = "steps/"
            fileName = step.id
        } else if let techStep = object as? TechStep {
            folderName = "techSteps/"
            fileName = techStep.id
        } else if let responsible = object as? Responsible {
            folderName = "responsibles/"
            fileName = responsible.id
        } else if let system = object as? System {
            folderName = "systems/"
            fileName = system.id
        } else {
            print("E: Didn't find a correct data type to delete data for disk")
        }
        
        switch dataSourceType {
        case .LocalJSON:
            fileName += ".json"
        default:
            print("E: dataSourceType is incorrect")
        }
        
        try fileManager.removeItem(atPath: workingDirectory + folderName + fileName)
    }
    
    mutating func initData(projectName: String) throws -> (DataSourceType, DataCollection)  {
        // set the working directory to project directory
        self.workingDirectory = appDirectory + "projects/" + projectName + "/"
        var dataSourceType = DataSourceType.None
        
        if let dataTypeFile = self.fileManager.contents(atPath: self.workingDirectory + "DATASOURCETYPE") {
            let dataType = String(decoding: dataTypeFile, as: UTF8.self)
            switch dataType {
            case "LocalJSON\n":
                dataSourceType = .LocalJSON
            default:
                dataSourceType = .None
            }
        } else {
            print("E: Can't get the data type for the project \(projectName)")
        }
        
        var dataCollection = DataCollection.createEmpty()
        
        // Solutions
        dataCollection.solutions = try readData(dataSourceType: dataSourceType, dataType: Solution.self, folderName: "solutions")
        
        // Tags
        dataCollection.tags = try readData(dataSourceType: dataSourceType, dataType: Tag.self, folderName: "tags")
        
        // Processes
        dataCollection.processes = try readData(dataSourceType: dataSourceType, dataType: DDProcess.self, folderName: "processes")
        
        // Flows
        dataCollection.flows = try readData(dataSourceType: dataSourceType, dataType: Flow.self, folderName: "flows")
        
        // Steps
        dataCollection.steps = try readData(dataSourceType: dataSourceType, dataType: Step.self, folderName: "steps")
        
        // TechSteps
        dataCollection.techSteps = try readData(dataSourceType: dataSourceType, dataType: TechStep.self, folderName: "techSteps")
        
        // Responsibles
        dataCollection.responsibles = try readData(dataSourceType: dataSourceType, dataType: Responsible.self, folderName: "responsibles")
        
        // Systems
        dataCollection.systems = try readData(dataSourceType: dataSourceType, dataType: System.self, folderName: "systems")
        
        return (dataSourceType, dataCollection)
    }
    
    func changeStep(_ step: Step, dataSourceType: DataSourceType) throws {
        switch dataSourceType {
        case .LocalJSON:
            let stepFile = try jsonEncoder.encode(step)
            fileManager.createFile(atPath:  "\(self.workingDirectory)steps/\(step.id).json", contents: stepFile)
        default:
            print("E: Data source type is incorrect")
        }
        
    }
    
    func changeFlow(_ flow: Flow, dataSourceType: DataSourceType) throws {
        switch dataSourceType {
        case .LocalJSON:
            let flowFile = try jsonEncoder.encode(flow)
            fileManager.createFile(atPath:  "\(self.workingDirectory)flows/\(flow.id).json", contents: flowFile)
        default:
            print("E: Data source type is incorrect")
        }
        
    }
    
    func changeSystem(_ system: System, dataSourceType: DataSourceType) throws {
        switch dataSourceType {
        case .LocalJSON:
            let systemFile = try jsonEncoder.encode(system)
            fileManager.createFile(atPath:  "\(self.workingDirectory)systems/\(system.id).json", contents: systemFile)
        default:
            print("E: Data source type is incorrect")
        }
    }
    
    func changeSolution(_ solution: Solution, dataSourceType: DataSourceType) throws {
        switch dataSourceType {
        case .LocalJSON:
            let solutionFile = try jsonEncoder.encode(solution)
            fileManager.createFile(atPath:  "\(self.workingDirectory)solutions/\(solution.id).json", contents: solutionFile)
        default:
            print("E: Data source type is incorrect")
        }
    }
    
    func changeResponsible(_ responsible: Responsible, dataSourceType: DataSourceType) throws {
        switch dataSourceType {
        case .LocalJSON:
            let responsibleFile = try jsonEncoder.encode(responsible)
            fileManager.createFile(atPath:  "\(self.workingDirectory)responsibles/\(responsible.id).json", contents: responsibleFile)
        default:
            print("E: Data source type is incorrect")
        }
        
    }
}

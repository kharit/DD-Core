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
    func createDataReader<T>(dataSourceType: DataSourceType, dataType: T.Type, folderName: String) -> (() throws -> [T]) where T : Decodable {
        return {
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
        let solutionReader = createDataReader(dataSourceType: dataSourceType, dataType: Solution.self, folderName: "solutions")
        dataCollection.solutions = try solutionReader()
        
        // Tags
        let tagReader = createDataReader(dataSourceType: dataSourceType, dataType: Tag.self, folderName: "tags")
        dataCollection.tags = try tagReader()
        
        // Processes
        let processReader = createDataReader(dataSourceType: dataSourceType, dataType: DDProcess.self, folderName: "processes")
        dataCollection.processes = try processReader()
        
        // Flows
        let flowReader = createDataReader(dataSourceType: dataSourceType, dataType: Flow.self, folderName: "flows")
        dataCollection.flows = try flowReader()
        
        // Steps
        let stepReader = createDataReader(dataSourceType: dataSourceType, dataType: Step.self, folderName: "steps")
        dataCollection.steps = try stepReader()
        
        // TechSteps
        let techStepReader = createDataReader(dataSourceType: dataSourceType, dataType: TechStep.self, folderName: "techSteps")
        dataCollection.techSteps = try techStepReader()
        
        // Responsibles
        let responsibleReader = createDataReader(dataSourceType: dataSourceType, dataType: Responsible.self, folderName: "responsibles")
        dataCollection.responsibles = try responsibleReader()
        
        // Systems
        let systemReader = createDataReader(dataSourceType: dataSourceType, dataType: System.self, folderName: "systems")
        dataCollection.systems = try systemReader()
        
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

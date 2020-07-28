//
//  DataManager.swift
//  
//
//  Created by Vasiliy Kharitonov on 27.07.2020.
//
// High level data management. Will call text processing from here (indirectly)

import Foundation

public class DataManager {
    
    var dataCollection: DataCollection   // source data
    public var displayData: DataCollection
    
    // Displayed data is generated with functions
    public func chooseSolution(_ solution: Solution) {
        let correctProcesses = dataCollection.processes.compactMap({(process: DDProcess) -> DDProcess? in
            if solution.processes.contains(process.id) {
                return process
            } else {
                return nil
            }
        })
        
        print(correctProcesses)
        
        displayData.processes = correctProcesses
    }
    
    func chooseTag() {
        
    }
    
    func chooseProcess() {
        
    }
    
    init(dataCollection: DataCollection) {
        self.dataCollection = dataCollection
        self.displayData = dataCollection
    }
}

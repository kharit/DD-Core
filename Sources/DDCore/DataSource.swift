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
    
}

enum DataSourceType {
    case None   // for testing purposes
    case Local
    case RemoteGit
    case API
}

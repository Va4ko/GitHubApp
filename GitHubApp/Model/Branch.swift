//
//  Branch.swift
//  GitHubApp
//
//  Created by Ivan Ivanov on 9.08.22.
//

import Foundation

struct Branch: Codable {
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
    }
}

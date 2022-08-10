//
//  Repos.swift
//  GitHubApp
//
//  Created by Ivan Ivanov on 8.08.22.
//

import Foundation

struct Repo: Codable {
    let name: String?
    let language: String?
    let updatedAt: String?
    let branchesURL: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case language = "language"
        case updatedAt = "updated_at"
        case branchesURL = "branches_url"
    }
    
}

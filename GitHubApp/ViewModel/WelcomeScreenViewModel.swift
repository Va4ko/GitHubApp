//
//  WelcomeScreenViewModel.swift
//  GitHubApp
//
//  Created by Ivan Ivanov on 8.08.22.
//

import Foundation

class WelcomeScreenViewModel {
    
    let dataSource = DataSource()
    
    func getData(userName: String, completion: @escaping () -> Void) {
        
        dataSource.getRepos(username: userName) {
            completion()
        }
    }
    
    func getBranchesData(userName: String, repoName: String, completion: @escaping () -> Void) {
        
        dataSource.getBranches(userName: userName, repoName: repoName) {
            completion()
        }
    }
    
}

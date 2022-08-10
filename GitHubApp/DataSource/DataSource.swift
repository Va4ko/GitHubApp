//
//  DataSource.swift
//  GitHubApp
//
//  Created by Ivan Ivanov on 8.08.22.
//

import Foundation
import UIKit

class DataSource {
    private let urlBase = URL(string: "https://api.github.com/users/")
    private let branchesURLBase = URL(string: "https://api.github.com/repos/")
    
    var repos: [Repo]?
    var branches: [Branch]?
    
    func getRepos(username: String, completion: @escaping () -> Void) {
        
        guard let url = URL(string: "\(urlBase!)\(username)/repos") else {
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print("Something goes wrong: \(error!)")
                DispatchQueue.main.async {
                    popAlert(message: "Something goes wrong: \(error!)") {
                        
                    }
                }
                
            } else {
                guard let responseData = data else {
                    print ("Something goes wrong!")
                    DispatchQueue.main.async {
                        popAlert(message: "Something goes wrong!") {
                            
                        }
                    }
                    
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let data = try decoder.decode([Repo].self, from: responseData)
                    self.repos = data
                    
                } catch let error {
                    print("Error in parsing json file \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        popAlert(message: "No such user") {
                            
                        }
                    }
                    
                }
                
                
            }
            completion()
        })
        
        dataTask.resume()
        
    }
    
    func getBranches(userName: String, repoName: String, completion: @escaping () -> Void) {
        guard let url = URL(string: "\(branchesURLBase!)\(userName)/\(repoName)/branches") else {
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print("Something goes wrong: \(error!)")
                DispatchQueue.main.async {
                    popAlert(message: "Something goes wrong: \(error!)") {
                        
                    }
                }
                
            } else {
                guard let responseData = data else {
                    print ("Something goes wrong!")
                    DispatchQueue.main.async {
                        popAlert(message: "Something goes wrong!") {
                            
                        }
                    }
                    
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let data = try decoder.decode([Branch].self, from: responseData)
                    self.branches = data
                    
                } catch let error {
                    print("Error in parsing json file \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        popAlert(message: "Error in parsing json file \(error.localizedDescription)") {
                            
                        }
                    }
                    
                }
                
                
            }
            completion()
        })
        
        dataTask.resume()
    }
}

//
//  DataSource.swift
//  GitHubApp
//
//  Created by Ivan Ivanov on 8.08.22.
//

import Foundation
import UIKit

class DataSource {
    
    //MARK: Properties
    private let urlBase = URL(string: "https://api.github.com/users/")
    private let branchesURLBase = URL(string: "https://api.github.com/repos/")
    
    var repos: [Repo]?
    var branches: [Branch]?
    
    /// Fetching user's repositories
    func getRepos(username: String, completion: @escaping () -> Void) {
        
        guard let url = URL(string: "\(urlBase!)\(username)/repos") else {
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.urlCache = nil
        
        let session = URLSession(configuration: configuration)
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print("Something goes wrong: \(error!)")
                
                let message = ["message": "Something goes wrong: Maybe you don't have internet or the server is down :("]
                NotificationCenter.default.post(name: Notification.Name("NetworkError"), object: nil, userInfo: message)
                
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
                    
                    let message = ["message": "No such user"]
                    NotificationCenter.default.post(name: Notification.Name("Error"), object: nil, userInfo: message)
                }
                
            }
            completion()
        })
        
        dataTask.resume()
        
    }
    
    /// Fetching user's repositories branches
    func getBranches(userName: String, repoName: String, completion: @escaping () -> Void) {
        guard let url = URL(string: "\(branchesURLBase!)\(userName)/\(repoName)/branches") else {
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.urlCache = nil
        
        let session = URLSession(configuration: configuration)
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print("Something goes wrong: \(error!)")
                DispatchQueue.main.async {
                    popAlert(message: "Something goes wrong: Something goes wrong: Maybe you don't have internet or the server is down :(") {
                        
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

//
//  Dashboard.swift
//  GitHubApp
//
//  Created by Ivan Ivanov on 9.08.22.
//

import UIKit

class Dashboard: UIViewController {
    
    //MARK: Properties
    var viewModel: WelcomeScreenViewModel?
    let defaults = UserDefaults.standard
    
    
    //MARK: IBOutlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshData))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    @objc func refreshData() {
        
        activityIndicator.startAnimating()
        
        guard let user = self.title else { return }
        
        guard let viewModel = viewModel else { return }
        viewModel.getData(userName: user) {
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
            }
            
        }
    }
    
    @objc func logout() {
        navigationController?.popViewController(animated: true)
        viewModel?.dataSource.repos = nil
        self.defaults.set(nil, forKey: "user")
    }
    
}

extension Dashboard: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let user = self.title else { return }
        guard let viewModel = viewModel else { return }
        guard let repos = viewModel.dataSource.repos else { return }
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let branchesViewController = mainStoryboard.instantiateViewController(withIdentifier: "Branches") as! BranchesViewController
        
        viewModel.getBranchesData(userName: user, repoName: repos[indexPath.row].name!) {
            
            DispatchQueue.main.sync {
                if let label = repos[indexPath.row].name {
                    branchesViewController.title = "\(label) Branches"
                }
                branchesViewController.viewModel = viewModel
                branchesViewController.activityIndicator.stopAnimating()
                branchesViewController.tableView.reloadData()
            }
            
        }
        self.navigationController?.pushViewController(branchesViewController, animated: true)
    }
}

extension Dashboard: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        guard let repos = viewModel.dataSource.repos else {
            return 0
        }
        return repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        
        guard let viewModel = viewModel else { return cell }
        guard let repos = viewModel.dataSource.repos else {
            return cell
        }
        
        let dateOfUpdate = formatDate(date: repos[indexPath.row].updatedAt!)
        let timeSinceUpdate = convertDate(dateString: dateOfUpdate)
        
        content.text = repos[indexPath.row].name
        content.secondaryText = "Updated on \(dateOfUpdate) | \(timeSinceUpdate) ago"
        content.imageProperties.maximumSize = CGSize(width: 50, height: 50)
        
        switch repos[indexPath.row].language {
            case "Swift":
                content.image = UIImage(named: "swift")
            case "Go":
                content.image = UIImage(named: "go")
            case "HTML":
                content.image = UIImage(named: "html")
            case "Java":
                content.image = UIImage(named: "java")
            case "Javascript":
                content.image = UIImage(named: "javascript")
            case "PHP":
                content.image = UIImage(named: "php")
            case "Python":
                content.image = UIImage(named: "python")
            default:
                content.image = UIImage(named: "language")
        }
        
        cell.contentConfiguration = content
        
        return cell
    }
    
}

//
//  BranchesViewController.swift
//  GitHubApp
//
//  Created by Ivan Ivanov on 9.08.22.
//

import UIKit

class BranchesViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: Properties
    var viewModel: WelcomeScreenViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}

extension BranchesViewController: UITableViewDelegate {
    
}

extension BranchesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        guard let branches = viewModel.dataSource.branches else {
            return 0
        }
        return branches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        
        guard let viewModel = viewModel else { return cell }
        guard let branches = viewModel.dataSource.branches else {
            return cell
        }
        
        content.text = branches[indexPath.row].name
        cell.contentConfiguration = content
        
        return cell
    }
    
    
}

//
//  ViewController.swift
//  GitHubApp
//
//  Created by Ivan Ivanov on 8.08.22.
//

import UIKit

class WelcomeScreen: UIViewController {
    
    // MARK: Properties
    let viewModel = WelcomeScreenViewModel()
    
    
    // MARK: IBOutlets
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var goBtn: UIButton!
    
    //MARK: IBActions
    @IBAction func goBtnTapped(_ sender: Any) {
        
        if let user = userNameTextField.text {
            guard !user.isEmpty else {
                popAlert(message: "Please enter some text") {
                    
                }
                return
            }
            
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let dashboardViewController = mainStoryboard.instantiateViewController(withIdentifier: "Dashboard") as! Dashboard
            
            viewModel.getData(userName: user) {
                
                DispatchQueue.main.sync {
                    
                    dashboardViewController.title = user
                    dashboardViewController.viewModel = self.viewModel
                    dashboardViewController.activityIndicator.stopAnimating()
                    
                }
                DispatchQueue.main.async {
                    dashboardViewController.tableView.reloadData()
                }
                
            }
            self.navigationController?.pushViewController(dashboardViewController, animated: true)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        setBackground(named: "background")
        
        NotificationCenter.default.addObserver(self, selector: #selector(showAlert(_:)), name: Notification.Name("Error"), object: nil)
    }
    
    @objc func showAlert(_ notification: NSNotification) {
        if let message = notification.userInfo!["message"] as? String {
            DispatchQueue.main.async {
                popAlert(message: message) {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}

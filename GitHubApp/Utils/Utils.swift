//
//  Utils.swift
//  GitHubApp
//
//  Created by Ivan Ivanov on 8.08.22.
//

import Foundation
import UIKit

func popAlert(message: String, onComplete: @escaping () -> Void) {
    let alert = UIAlertController(title: "Attention", message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
        alert.dismiss(animated: true, completion: {
            onComplete()
        })
    }))
    let currentViewController = currentVC()
    currentViewController.present(alert, animated: true)
}

public func currentVC() -> UIViewController {
    let keyWindow = UIWindow.key
    var currentViewCtrl: UIViewController = keyWindow!.rootViewController!
    while (currentViewCtrl.presentedViewController != nil) {
        currentViewCtrl = currentViewCtrl.presentedViewController!
    }
    return currentViewCtrl
}

func convertDate(dateString: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd.MM.yyyy"
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .none
    let date = dateFormatter.date(from: dateString)
    
    let timeInterval = Date().timeIntervalSince(date!)
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.hour, .minute, .second]
    formatter.unitsStyle = .abbreviated
    
    let formattedString = formatter.string(from: TimeInterval(timeInterval))!
    
    return formattedString
}

func formatDate(date: String) -> String {
    let dateFormatterGet = DateFormatter()
    dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .none
    
    let dateObj: Date? = dateFormatterGet.date(from: date)
    
    return dateFormatter.string(from: dateObj!)
}

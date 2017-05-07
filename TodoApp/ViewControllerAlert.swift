//
//  ViewControllerAlert.swift
//  TodoApp
//
//  Created by Sean Perez on 5/6/17.
//  Copyright © 2017 SeanPerez. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showErrorAlert(title: String?, message: String?) {
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        showAlert(title: title, message: message, actions: [action])
    }
    
    func showAlert(title: String?, message: String?, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { alert.addAction($0) }
        present(alert, animated: true, completion: nil)
    }
}

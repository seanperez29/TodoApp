//
//  ChecklistItemDetailVC.swift
//  TodoApp
//
//  Created by Sean Perez on 5/6/17.
//  Copyright © 2017 SeanPerez. All rights reserved.
//

import UIKit
import RealmSwift

class ChecklistItemDetailVC: UITableViewController {
    
    @IBOutlet weak var checklistItemText: UITextField!
    @IBOutlet weak var priorityControl: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func createChecklistItem(_ sender: Any) {
        do {
            let realm = try Realm()
            guard let text = checklistItem.text, text != "" else { return }
            let checklistItem = ChecklistItem(text: text, priority: setPriority())
            try! realm.write {
                realm.add(checklistItem)
            }
        } catch let error as NSError {
            print(error)
            showErrorAlert(title: "We experienced a problem", message: "Please try again")
        }
        
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func setPriority() -> Int {
        return priorityControl.isOn ? 0 : 1
    }
    
}

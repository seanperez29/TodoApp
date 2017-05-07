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
    @IBOutlet weak var doneButton: UIBarButtonItem!
    var itemToEdit: ChecklistItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        if itemToEdit != nil {
            title = "Edit Item"
            checklistItemText.text = itemToEdit!.text
            priorityControl.isOn = !(itemToEdit!.priority as NSNumber).boolValue
        }
    }

    @IBAction func createChecklistItem(_ sender: Any) {
        if itemToEdit == nil {
            do {
                let realm = try Realm()
                guard let text = checklistItemText.text, text != "" else { return }
                let checklistItem = ChecklistItem(text: text, priority: setPriority())
                try! realm.write {
                    realm.add(checklistItem)
                }
                navigationController?.popViewController(animated: true)
            } catch let error as NSError {
                print(error)
                showErrorAlert(title: "We experienced a problem", message: "Please try again")
            }
        } else {
            do {
                let realm = try Realm()
                guard let text = checklistItemText.text, text != "" else { return }
                try! realm.write {
                    itemToEdit!.text = checklistItemText.text
                    itemToEdit!.priority = setPriority()
                    itemToEdit!.created = Date()
                }
                navigationController?.popViewController(animated: true)
            } catch {
                print(error)
                showErrorAlert(title: "We experienced a problem", message: "Please try again")
            }
        }
        
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func setPriority() -> Int {
        return priorityControl.isOn ? 0 : 1
    }
    
}

extension ChecklistItemDetailVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
        doneButton.isEnabled = (newText.length > 0)
        return true
    }
}

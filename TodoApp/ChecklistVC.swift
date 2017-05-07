//
//  ChecklistVC.swift
//  TodoApp
//
//  Created by Sean Perez on 5/6/17.
//  Copyright © 2017 SeanPerez. All rights reserved.
//

import UIKit
import RealmSwift

class ChecklistVC: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var priorityBarButton: UIBarButtonItem!
    @IBOutlet weak var dateButton: UIBarButtonItem!
    var checklistItems: Results<ChecklistItem>!

    override func viewDidLoad() {
        super.viewDidLoad()
        checklistItems = sortByCompleted(completed: false)
        let tap = UITapGestureRecognizer(target: self, action: #selector(ChecklistVC.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func sortByCompleted(completed: Bool) -> Results<ChecklistItem> {
        do {
            let realm = try Realm()
            checklistItems = realm.objects(ChecklistItem.self)
            if completed {
                checklistItems = checklistItems.filter("completed = true")
            }
        } catch {
            showErrorAlert(title: "We experienced a problem", message: "Please try again")
        }
        return checklistItems.sorted(by: [SortDescriptor(keyPath: "priority", ascending: true), SortDescriptor(keyPath: "created", ascending: false)])
    }
    
    @IBAction func toggleDate(_ sender: Any) {
        if dateButton.title == "Newer" {
            dateButton.title = "Older"
            checklistItems = checklistItems.sorted(by: [SortDescriptor(keyPath: "created", ascending: true)])
        } else {
            dateButton.title = "Newer"
            checklistItems = checklistItems.sorted(by: [SortDescriptor(keyPath: "created", ascending: false)])
        }
        tableView.reloadData()
    }
    
    
    @IBAction func togglePriority(_ sender: Any) {
        if priorityBarButton.title == "High" {
            priorityBarButton.title = "Low"
            checklistItems = checklistItems.sorted(by: [SortDescriptor(keyPath: "priority", ascending: false)])
        } else {
            priorityBarButton.title = "High"
            checklistItems = checklistItems.sorted(by: [SortDescriptor(keyPath: "priority", ascending: true)])
        }
        tableView.reloadData()
    }
    
    
    @IBAction func toggleSortByComplete(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        checklistItems = sortByCompleted(completed: sender.isSelected)
        tableView.reloadData()
    }
    
    func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditItem" {
            let controller = segue.destination as! ChecklistItemDetailVC
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = checklistItems[indexPath.row]
            }
        }
    }
    

}

//MARK: - Tableview Delegate and DataSource
extension ChecklistVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklistItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.ChecklistCell, for: indexPath) as! ChecklistItemCell
        let checklistItem = checklistItems[indexPath.row]
        cell.configureCell(checklistItem)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) as? ChecklistItemCell {
            let checklistItem = checklistItems[indexPath.row]
            cell.updateChecklistItem(!checklistItem.completed)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            do {
                try checklistItems.realm?.write {
                    let checklistItem = checklistItems[indexPath.row]
                    checklistItems.realm?.delete(checklistItem)
                }
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch {
                showErrorAlert(title: "We experienced a problem", message: "Please try again")
            }
        }
    }
    
}

extension ChecklistVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        do {
            let realm = try Realm()
            let predicate = NSPredicate(format: "text CONTAINS [c] %@", searchBar.text!)
            checklistItems = realm.objects(ChecklistItem.self).filter(predicate)
            tableView.reloadData()
        } catch {
            showErrorAlert(title: "We experienced a problem", message: "Please try again")
        }
    }
}



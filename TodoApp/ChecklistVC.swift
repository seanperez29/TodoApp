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

    var checklistItems: Results<ChecklistItem>!

    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            let realm = try Realm()
            checklistItems = realm.objects(ChecklistItem)
        } catch let error as NSError {
            print(error)
            showErrorAlert(title: "We experienced a problem", message: "Please try again")
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
    
}

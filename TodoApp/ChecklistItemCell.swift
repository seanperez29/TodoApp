//
//  ChecklistItemCell.swift
//  TodoApp
//
//  Created by Sean Perez on 5/6/17.
//  Copyright © 2017 SeanPerez. All rights reserved.
//

import UIKit
import RealmSwift

class ChecklistItemCell: UITableViewCell {
    
    @IBOutlet weak var checklistText: UILabel!
    @IBOutlet weak var checkmarkLabel: UILabel!
    var itemID: String?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(_ checklistItem: ChecklistItem) {
        itemID = checklistItem.itemID
        checklistText.text = checklistItem.text
        checkmarkLabel.text = configureCheckmark(for: checklistItem)
    }
    
    func updateChecklistItem(_ completed: Bool) {
        if let realm = try? Realm(), let id = itemID, let checklistItem = realm.object(ofType: ChecklistItem.self, forPrimaryKey: id) {
            try! realm.write {
                checklistItem.completed = completed
            }
            checkmarkLabel.text = configureCheckmark(for: checklistItem)
        }
    }
    
    func configureCheckmark(for checklistItem: ChecklistItem) -> String {
        return checklistItem.completed ? "√" : ""
    }
}

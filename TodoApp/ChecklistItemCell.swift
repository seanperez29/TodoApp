//
//  ChecklistItemCell.swift
//  TodoApp
//
//  Created by Sean Perez on 5/6/17.
//  Copyright © 2017 SeanPerez. All rights reserved.
//

import UIKit

class ChecklistItemCell: UITableViewCell {
    
    @IBOutlet weak var checklistText: UILabel!
    @IBOutlet weak var checkmarkLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(_ checklistItem: ChecklistItem) {
        checklistText.text = checklistItem.text
        checkmarkLabel.text = checklistItem.completed ? "√" : ""
    }
}

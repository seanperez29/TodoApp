//
//  ChecklistItem.swift
//  TodoApp
//
//  Created by Sean Perez on 5/6/17.
//  Copyright © 2017 SeanPerez. All rights reserved.
//

import Foundation
import RealmSwift

class ChecklistItem: Object {
    
    dynamic var itemID = NSUUID().uuidString
    dynamic var text: String!
    dynamic var completed = false
    dynamic var created = Date()
    dynamic var priority = 0
    
    override class func primaryKey() -> String {
        return "itemID"
    }
    
    override class func indexedProperties() -> [String] {
        return ["completed", "created"]
    }
    
    convenience init(text: String, priority: Int) {
        self.init()
        self.text = text
        self.priority = priority
    }
}

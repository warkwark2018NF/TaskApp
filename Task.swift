//
//  Task.swift
//  taskapp
//
//  Created by FUSAMAMASAKI on 2020/08/05.
//  Copyright © 2020 FUSAMAMASAKI. All rights reserved.
//

import Foundation
import RealmSwift

class Task:Object {
    @objc dynamic var id = 0
    @objc dynamic var title = ""
    @objc dynamic var contents = ""
    @objc dynamic var date = Date()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

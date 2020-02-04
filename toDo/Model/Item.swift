//
//  Item.swift
//  toDo
//
//  Created by Abdul Diallo on 1/31/20.
//  Copyright © 2020 Abdul Diallo. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var date : Date?
    //relationship
    let parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}

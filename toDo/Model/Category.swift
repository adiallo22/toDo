//
//  Category.swift
//  toDo
//
//  Created by Abdul Diallo on 1/31/20.
//  Copyright © 2020 Abdul Diallo. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    //relationship
    let items = List<Item>()
}

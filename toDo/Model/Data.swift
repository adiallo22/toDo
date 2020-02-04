//
//  Data.swift
//  toDo
//
//  Created by Abdul Diallo on 1/31/20.
//  Copyright © 2020 Abdul Diallo. All rights reserved.
//

import Foundation
import RealmSwift

class Data : Object {
    
    @objc dynamic var name : String = ""
    @objc dynamic var age : Int = 0
    
}

//
//  Quote.swift
//  toDo
//
//  Created by Abdul Diallo on 5/27/20.
//  Copyright © 2020 Abdul Diallo. All rights reserved.
//

import Foundation
import Firebase

class Quote {
    
    var quote : String?
    var author : String?
    var likes : Int = 0
    let ref : DatabaseReference!

    init(snapshot : DataSnapshot) {
        ref = snapshot.ref
        if let value = snapshot.value as? [String:Any] {
            quote = value["quote"] as! String
            author = value["author"] as! String
            likes = value["likes"] as! Int
        }
    }
    
    init(quote : String, author : String) {
        ref = Database.database().reference().child("quotes").childByAutoId()
        self.quote = quote
        self.author = author
    }
    
    func setDictionary() -> [String:Any] {
        return [
            "quote":quote!,
            "author":author!,
            "likes":likes,
            "uid": Auth.auth().currentUser!.uid
        ]
    }
    
    func saveToFirebase() {
        ref.setValue(setDictionary())
    }
    
    func likeCliked() {
        likes += 1
        ref.child("likes").setValue(likes)
    }
    
}

//
//  CloudFirestore.swift
//  UseCoreNFC
//
//  Created by 神村亮佑 on 2020/11/12.
//

import Foundation
import FirebaseDatabase

struct FirestoreDB {
    func loadDB() {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref.child("fruits/01").setValue(["name": "ジュン", "gender":"男","type":"リス"])
    }
}

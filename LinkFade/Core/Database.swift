//
//  Database.swift
//  LinkFade
//
//  Created by Oleksandr Mytryniuk on 05.12.2022.
//

import FirebaseFirestore

struct Database {
    static let shared = Database()
    
    private let instance: Firestore
    
    var userProfiles: CollectionReference {
        instance.collection("userProfiles")
    }
    
    private init() {
        instance = Firestore.firestore()
    }
}

//
//  MenuViewModel.swift
//  LinkFade
//
//  Created by Oleksandr Mytryniuk on 05.12.2022.
//

import FirebaseAuth
import FirebaseFirestore

final class MenuViewModel: MenuViewModelProtocol {
    private var listener: AuthStateDidChangeListenerHandle?
    
    var binding: ((UserData) -> Void)?
    
    func addListener() {
        listener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.fetchUserName(from: user) { userName in
                let photoURL = user?.photoURL
                let email = user?.email
                self?.binding?(UserData(photoURL: photoURL, userName: userName, email: email))
            }
        }
    }
    
    private func fetchUserName(from user: User?, completion: @escaping (String?) -> Void) {
        guard let userId = user?.uid else {
            completion(nil)
            return
        }
        let collection = Firestore.firestore().collection("userProfiles")
        let query = collection.whereField("userId", isEqualTo: userId)
        query.getDocuments { snapshot, error in
            let profileData = snapshot?.documents.first?.data()
            if error == nil, let profileData, let profile = UserProfile(data: profileData) {
                completion(profile.fullName)
            } else {
                completion(nil)
            }
        }
    }
    
    func removeListener() {
        if let listener {
            Auth.auth().removeStateDidChangeListener(listener)
        }
    }
    
    func signOut(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
}

//
//  SignUpService.swift
//  LinkFade
//
//  Created by Oleksandr Mytryniuk on 03.12.2022.
//

import FirebaseAuth
import FirebaseFirestore

final class SignUpService: SignUpServiceProtocol {
    private let profileBuilder: UserProfileBuilder?
    private let credentials: SignUpCredentials?
    
    init(profileBuilder: UserProfileBuilder?, credentials: SignUpCredentials?) {
        self.profileBuilder = profileBuilder
        self.credentials = credentials
    }
    
    func signUp(completion: @escaping Completion) {
        guard let email = credentials?.email, let password = credentials?.password else {
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            let userId = result?.user.uid
            if let error {
                completion(.failure(error))
            } else if let userId, let profile = self?.profileBuilder?.userId(userId).make() {
                self?.saveUserProfile(profile, completion: completion)
            }
        }
    }
    
    private func saveUserProfile(_ profile: UserProfile, completion: @escaping Completion) {
        let collection = Firestore.firestore().collection("userProfiles")
        var document: DocumentReference?
        collection.getDocuments { snapshot, error in
            if let error {
                completion(.failure(error))
            } else {
                profile.graphNode = snapshot?.count
                document = collection.addDocument(data: profile.data) { error in
                    if let error {
                        completion(.failure(error))
                    } else if let id = document?.documentID {
                        NSLog("Збережено документ профілю користувача з ідентифікатором: \(id)")
                        completion(.success(()))
                    }
                }
            }
        }
    }
}

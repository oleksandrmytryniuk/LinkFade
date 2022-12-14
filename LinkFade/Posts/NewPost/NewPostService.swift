//
//  NewPostService.swift
//  LinkFade
//
//  Created by Oleksandr Mytryniuk on 14.12.2022.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

final class NewPostService: NewPostServiceProtocol {
    private var listener: AuthStateDidChangeListenerHandle?
    private var currentUser: User?
    
    private var userProfiles: CollectionReference {
        Firestore.firestore().collection("userProfiles")
    }
    
    private var posts: CollectionReference {
        Firestore.firestore().collection("posts")
    }
    
    private var storageReference: StorageReference {
        Storage.storage().reference()
    }
    
    private var formattedCurrentDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy_MM_dd_HH_mm_ss"
        return formatter.string(from: Date())
    }
    
    func addListener() {
        listener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.currentUser = user
        }
    }
    
    func removeListener() {
        if let listener {
            Auth.auth().removeStateDidChangeListener(listener)
        }
    }
    
    func savePost(text: String, imageData: Data, completion: @escaping (Error?) -> Void) {
        currentUserProfile { [weak self] profile in
            if let profile {
                self?.uploadPostImage(data: imageData, userId: profile.userId) { url in
                    self?.addPostDocument(
                        profile: profile,
                        text: text,
                        imageURL: url,
                        completion: completion
                    )
                }
            } else {
                completion(NSError())
            }
        }
    }
    
    private func currentUserProfile(completion: @escaping (UserProfile?) -> Void) {
        guard let userId = currentUser?.uid else {
            completion(nil)
            return
        }
        let query = userProfiles.whereField("userId", isEqualTo: userId).limit(to: 1)
        query.getDocuments { snapshot, error in
            if let data = snapshot?.documents.first?.data() {
                completion(UserProfile(data: data))
            } else {
                completion(nil)
            }
        }
    }
    
    private func uploadPostImage(
        data: Data,
        userId: String,
        completion: @escaping (URL?) -> Void
    ) {
        let reference = storageReference.child("posts/\(userId)_\(formattedCurrentDate)")
        reference.putData(data) { metadata, error in
            if error == nil {
                reference.downloadURL { url, error in
                    completion(url)
                }
            } else {
                completion(nil)
            }
        }
    }
    
    private func addPostDocument(
        profile: UserProfile,
        text: String,
        imageURL: URL?,
        completion: @escaping (Error?) -> Void
    ) {
        let post = makePost(profile: profile, text: text, imageURL: imageURL)
        var reference: DocumentReference?
        reference = posts.addDocument(data: post.data) { error in
            if error == nil, let documentId = reference?.documentID {
                print("Додано новий допис з ідентифікатором \(documentId).")
            }
            completion(error)
        }
    }
    
    private func makePost(profile: UserProfile, text: String, imageURL: URL?) -> Post {
        Post(
            text: text,
            imageURL: imageURL,
            publishingDate: Date(),
            userId: profile.userId,
            userPhotoURL: profile.photoURL,
            userName: profile.fullName
        )
    }
}

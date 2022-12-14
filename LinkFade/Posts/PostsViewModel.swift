//
//  PostsViewModel.swift
//  LinkFade
//
//  Created by Oleksandr Mytryniuk on 13.12.2022.
//

import FirebaseAuth
import FirebaseFirestore

final class PostsViewModel: PostsViewModelProtocol {
    private var listener: AuthStateDidChangeListenerHandle?
    private var currentUser: User?
    private var posts: [Post] = []
    
    var showsUserOnly: Bool = false
    weak var delegate: PostsViewModelDelegate?
    
    private var collection: CollectionReference {
        Firestore.firestore().collection("posts")
    }
    
    private var filteredPosts: [Post] {
        showsUserOnly ? posts.filter { $0.userId == currentUser?.uid } : posts
    }
    
    var postsCount: Int {
        filteredPosts.count
    }
    
    func addListener() {
        listener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.currentUser = user
            self?.loadPosts()
        }
    }
    
    private func loadPosts() {
        collection.getDocuments { [weak self] snapshot, error in
            if error == nil, let documents = snapshot?.documents {
                let fetchedPosts = documents.compactMap { Post(data: $0.data()) }
                self?.posts = fetchedPosts.sorted { $0.publishingDate > $1.publishingDate }
                self?.delegate?.viewModelDidLoadPosts(self)
            }
        }
    }
    
    func removeListener() {
        if let listener {
            Auth.auth().removeStateDidChangeListener(listener)
        }
    }
    
    func configureCell(_ cell: PostCell, forRowAt indexPath: IndexPath) {
        let post = filteredPosts[indexPath.item]
        cell.model = .init(
            userPhotoURL: post.userPhotoURL,
            userName: post.userName,
            publishingDate: post.publishingDate,
            text: post.text,
            imageURL: post.imageURL,
            deleteButtonIsHidden: post.userId != currentUser?.uid
        )
        cell.deleteAction = { [weak self] in
            self?.deletePost(post)
        }
    }
    
    private func deletePost(_ post: Post) {
        if let index = posts.firstIndex(where: { $0 == post }) {
            let query = collection
                .whereField("text", isEqualTo: post.text)
                .whereField("userId", isEqualTo: currentUser?.uid as Any)
            query.getDocuments { [weak self] snapshot, error in
                let predicate: (DocumentSnapshot) -> Bool = {
                    self?.document($0, hasDateEqualTo: post.publishingDate) ?? false
                }
                if let document = snapshot?.documents.first(where: predicate) {
                    let batch = Firestore.firestore().batch()
                    batch.deleteDocument(document.reference)
                    batch.commit()
                    self?.posts.remove(at: index)
                    let indexPath = IndexPath(row: index, section: 0)
                    self?.delegate?.viewModel(self, didDeleteRowAt: indexPath)
                }
            }
        }
    }
    
    private func document(_ document: DocumentSnapshot, hasDateEqualTo date: Date) -> Bool {
        guard let data = document.data() else {
            return false
        }
        return Post(data: data)?.publishingDate == date
    }
}

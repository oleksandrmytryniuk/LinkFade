//
//  FriendsSearchViewModel.swift
//  LinkFade
//
//  Created by Oleksandr Mytryniuk on 06.12.2022.
//

import FirebaseAuth
import FirebaseFirestore

final class FriendsSearchViewModel: FriendsSearchViewModelProtocol {
    private var listener: AuthStateDidChangeListenerHandle?
    private var user: User?
    private var timer: Timer?
    private var searchResults: [UserProfile] = [] {
        didSet {
            reloadAction?()
        }
    }
    
    var reloadAction: (() -> Void)?
    
    private var userProfiles: CollectionReference {
        Firestore.firestore().collection("userProfiles")
    }
    
    private var friendRequests: CollectionReference {
        Firestore.firestore().collection("friendRequests")
    }
    
    var searchResultsCount: Int {
        searchResults.count
    }
    
    func addListener() {
        listener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.user = user
        }
    }
    
    func removeListener() {
        if let listener {
            Auth.auth().removeStateDidChangeListener(listener)
        }
    }
    
    func searchBarTextDidChange(_ searchText: String) {
        let searchText = searchText.trimmingCharacters(in: .whitespaces).lowercased()
        guard !searchText.isEmpty else {
            searchResults = []
            return
        }
        resetTimer(userInfo: searchText)
    }
    
    private func resetTimer(userInfo: Any?) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(fireSearchEvent),
            userInfo: userInfo,
            repeats: false
        )
    }
    
    @objc private func fireSearchEvent(_ timer: Timer) {
        if let searchText = timer.userInfo as? String {
            executeQuery(searchText: searchText)
        }
    }
    
    private func executeQuery(searchText: String) {
        selectUnconnectedProfiles { [weak self] profiles in
            self?.searchResults = profiles.filter { $0.fullName.lowercased().contains(searchText) }
        }
    }
    
    private func selectUnconnectedProfiles(completion: @escaping ([UserProfile]) -> Void) {
        fetchCurrentUserProfile { [weak self] profile in
            self?.selectProfilesFromFriendRequests(userId: profile.userId) { identifiers in
                let query = self?.makeSelectionQuery(profile: profile, identifiers: identifiers)
                query?.getDocuments { snapshot, error in
                    if error == nil, let snapshot {
                        completion(snapshot.documents.compactMap { UserProfile(data: $0.data()) })
                    }
                }
            }
        }
    }
    
    private func fetchCurrentUserProfile(completion: @escaping (UserProfile) -> Void) {
        guard let userId = user?.uid else {
            return
        }
        userProfiles.whereField("userId", isEqualTo: userId).getDocuments { snapshot, error in
            let data = snapshot?.documents.first?.data()
            if error == nil, let data, let profile = UserProfile(data: data) {
                completion(profile)
            }
        }
    }
    
    private func selectProfilesFromFriendRequests(
        userId: String,
        completion: @escaping ([String]) -> Void
    ) {
        selectProfilesByField("sender", isEqualToUserId: userId) { [weak self] requests in
            var result = requests.map { $0.receiver }
            self?.selectProfilesByField("receiver", isEqualToUserId: userId) { requests in
                result.append(contentsOf: requests.map { $0.sender })
                completion(result)
            }
        }
    }
    
    private func selectProfilesByField(
        _ field: String,
        isEqualToUserId userId: String,
        completion: @escaping ([FriendRequest]) -> Void
    ) {
        friendRequests.whereField(field, isEqualTo: userId).getDocuments { snapshot, error in
            if error == nil, let snapshot {
                completion(snapshot.documents.compactMap { FriendRequest(data: $0.data()) })
            } else {
                completion([])
            }
        }
    }
    
    private func makeSelectionQuery(profile: UserProfile, identifiers: [String]) -> Query {
        var query = userProfiles.whereField("userId", isNotEqualTo: profile.userId)
        if !profile.friends.isEmpty {
            query = query.whereField("userId", notIn: profile.friends)
        }
        if !identifiers.isEmpty {
            query = query.whereField("userId", notIn: identifiers)
        }
        return query
    }
    
    func configureCell(_ cell: InviteFriendCell, forRowAt indexPath: IndexPath) {
        let profile = searchResults[indexPath.item]
        cell.configure(photoURL: profile.photoURL, userName: profile.fullName)
    }
}

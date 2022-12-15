//
//  FriendsViewModel.swift
//  LinkFade
//
//  Created by Oleksandr Mytryniuk on 11.12.2022.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class FriendsViewModel: FriendsViewModelProtocol {
    private var listener: AuthStateDidChangeListenerHandle?
    private var currentUser: User?
    private var tableContentType = TableContentType.friends
    private var recommendedProfiles = [UserProfile]() {
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
    
    var numberOfSections: Int {
        tableContentType == .friends ? 2 : 1
    }
    
    func addListener() {
        listener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.currentUser = user
            // TODO: fetch friends
            self?.fetchRecommendations()
        }
    }
    
    private func fetchRecommendations() {
        fetchCurrentUserProfile { [weak self] profile in
            self?.selectUnconnectedProfiles(for: profile) { profiles in
                self?.sendNetworkRequest(for: profile, unlinkedProfiles: profiles)
            }
        }
    }
    
    private func fetchCurrentUserProfile(completion: @escaping (UserProfile) -> Void) {
        guard let userId = currentUser?.uid else {
            return
        }
        userProfiles.whereField("userId", isEqualTo: userId).getDocuments { snapshot, error in
            let data = snapshot?.documents.first?.data()
            if error == nil, let data, let profile = UserProfile(data: data) {
                completion(profile)
            }
        }
    }
    
    private func selectUnconnectedProfiles(
        for profile: UserProfile,
        completion: @escaping ([UserProfile]) -> Void
    ) {
        selectProfilesFromFriendRequests(userId: profile.userId) { [weak self] identifiers in
            let query = self?.makeSelectionQuery(profile: profile, identifiers: identifiers)
            query?.getDocuments { snapshot, error in
                if error == nil, let snapshot {
                    completion(snapshot.documents.compactMap { UserProfile(data: $0.data()) })
                }
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
    
    private func sendNetworkRequest(for profile: UserProfile, unlinkedProfiles: [UserProfile]) {
        guard let request = makeRequest(for: profile, unlinkedProfiles: unlinkedProfiles) else {
            return
        }
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            self?.handleResponse(data: data, error: error, unlinkedProfiles: unlinkedProfiles)
        }
        task.resume()
    }
    
    private func makeRequest(
        for profile: UserProfile,
        unlinkedProfiles: [UserProfile]
    ) -> URLRequest? {
        guard let url = URL(string: "http://127.0.0.1:8000/linkfade") else {
            return nil
        }
        var request = URLRequest(url: url)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        request.httpBody = makeRequestData(profile: profile, unlinkedProfiles: unlinkedProfiles)
        return request
    }
    
    private func makeRequestData(profile: UserProfile, unlinkedProfiles: [UserProfile]) -> Data? {
        let destinationGraphNodes = unlinkedProfiles.compactMap { $0.graphNode }
        let sourceGraphNodes = Array(
            repeating: profile.graphNode,
            count: destinationGraphNodes.count
        )
        let data: [String: [Int]] = [
            "node_1": sourceGraphNodes.compactMap { $0 },
            "node_2": destinationGraphNodes
        ]
        return try? JSONEncoder().encode(data)
    }
    
    private func handleResponse(data: Data?, error: Error?, unlinkedProfiles: [UserProfile]) {
        if let error {
            NSLog(error.localizedDescription)
            return
        }
        if let data, let result = try? JSONDecoder().decode([String: [Int]].self, from: data) {
            let nodes = result["recommendedNodes"] ?? []
            recommendedProfiles = unlinkedProfiles.filter {
                if let node = $0.graphNode {
                    return nodes.contains(node)
                }
                return false
            }
        }
    }
    
    func removeListener() {
        if let listener {
            Auth.auth().removeStateDidChangeListener(listener)
        }
    }
    
    func selectedSegmentIndexDidChange(value: Int) {
        tableContentType = value == 0 ? .friends : .requests
        reloadAction?()
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        if tableContentType == .friends {
            return section == 0 ? 0 : recommendedProfiles.count
        }
        return 0
    }
    
    func titleForHeaderInSection(_ section: Int) -> String? {
        if tableContentType == .friends {
            return section == 0 ? nil : "Рекомендації"
        }
        return nil
    }
    
    func configureInviteFriendCell(_ cell: InviteFriendCell, forRowAt indexPath: IndexPath) {
        let profile = recommendedProfiles[indexPath.item]
        cell.configure(photoURL: profile.photoURL, userName: profile.fullName)
    }
}

//
//  Manager.swift
//  Threads
//
//  Created by Amir on 08.11.2019.
//  Copyright © 2019 Ildar Zalyalov. All rights reserved.
//

import UIKit

class Manager: DataManager {
    
    static let shared = Manager()
    
    private var posts: [Post] = []
    private var user: User!
    private let userDefaults = UserDefaults.standard
    
    init() {
        
        if let savedPosts = fetchData(posts, for: Constants.postsKey) {
            posts = savedPosts
        } else {
            posts = [Post(image: "postPhoto2", description: "Description 1", time: "1 час назад", likes: 23),
                     Post(image: "postPhoto3", description: "Description 2", time: "2 часа назад", likes: 33),
                     Post(image: "postPhoto4", description: "Description 3", time: "3 часа назад", likes: 43),
                     Post(image: "postPhoto5", description: "Description 4", time: "4 часа назад", likes: 53),
                     Post(image: "postPhoto6", description: "Description 5", time: "5 часов назад", likes: 34),
                     Post(image: "postPhoto7", description: "Description 6", time: "6 часов назад", likes: 230),
                     Post(image: "postPhoto8", description: "Description 7", time: "7 часов назад", likes: 213),
                     Post(image: "postPhoto9", description: "Description 8", time: "8 часов назад", likes: 36),
                     Post(image: "postPhoto10", description: "Description 9", time: "9 часов назад", likes: 76)]
            saveData(posts, for: Constants.postsKey)
        }
        
        if let savedUser = fetchData(user, for: Constants.userKey) {
            user = savedUser
        } else {
            user = User(nickName: "omeeer78", name: "Amir", profileImage: "profileImage2", posts: posts)
            saveData(user, for: Constants.userKey)
        }        
    }
    
    func syncSavePost(post: Post) {
        self.posts.append(post)
        saveData(posts, for: Constants.postsKey)
    }
    
    func asyncSavePost(post: Post, completion: @escaping () -> Void) {
        
        let operationQueue = OperationQueue()
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            let operation = BlockOperation { [weak self] in
                
                self?.posts.append(post)
                
                guard let posts = self?.posts else { return }
                
                self?.saveData(posts, for: Constants.postsKey)
                
                completion()
            }
            operationQueue.addOperation(operation)
        }
    }
    
    //MARK: - Search
    
    func syncSearchPost(for searchString: String) -> [Post] {
        
        let searchedPosts = posts.filter { (post) -> Bool in
            
            if let postText = post.description {
                return postText.contains(searchString)
            }
            return false
        }
        return searchedPosts
    }
    
    func asyncSearchPost(for searchString: String, completion: @escaping (([Post]) -> Void)) {
        
        let operationQueue = OperationQueue()
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            let operation = BlockOperation { [weak self] in
                
                let filteredPosts = self?.posts.filter({ post -> Bool in
                    return (post.description?.lowercased().contains(searchString.lowercased()))!
                })
                
                guard let filteredPostsUnwrapped = filteredPosts else { return }
                completion(filteredPostsUnwrapped)
            }
            operationQueue.addOperation(operation)
        }
    }
    
    //MARK: - Delete
    
    func syncDeletePost(with postID: String) {
        posts.removeAll { (post) -> Bool in
            post.postId == postID
        }
        saveData(posts, for: Constants.postsKey)
    }
    
    func asyncDeletePost(with post: Post, completion: @escaping ([Post]) -> Void) {
        
        let operationQueue = OperationQueue()
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            let operation = BlockOperation { [weak self] in
                
                self?.posts.removeAll(where: {$0.postId == post.postId})
                
                self?.saveData(self!.posts, for: Constants.postsKey)
                
                DispatchQueue.main.async { [weak self] in
                    
                    guard let postsArray = self?.fetchData(self?.posts, for: Constants.postsKey) else { return }
                    
                    completion(postsArray!)
                }
            }
            operationQueue.addOperation(operation)
        }
    }
    
    //MARK: - Get
    
    func syncGetPosts() -> [Post] {
        
        if let postsFromUD = fetchData(posts, for: Constants.postsKey) {
            posts = postsFromUD
        } else {
            saveData(posts, for: Constants.postsKey)
        }
        
        return self.posts
    }
    
    func asyncGetPosts(completion: @escaping (([Post]) -> Void)) {
        
        let operationQueue = OperationQueue()
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            let operation = BlockOperation { [weak self] in
                
                guard let postsArray = self?.fetchData(self?.posts, for: Constants.postsKey) else { return }
                
                completion(postsArray!)
            }
            operationQueue.addOperation(operation)
        }
    }
    
    func asyncGetUser(completion: @escaping (User) -> Void) {
        
        let operationQueue = OperationQueue()
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            let operation = BlockOperation { [weak self] in
                
                guard let user = self?.fetchData(self?.user, for: Constants.userKey) else { return }
                
                completion(user!)
            }
            operationQueue.addOperation(operation)
        }
    }
    
    //MARK: -  UserDefaults
    func saveData<T: Codable>(_ model: T, for key: String) {
        
        let encoder = JSONEncoder()
        let jsonData = try! encoder.encode(model)
        userDefaults.set(jsonData, forKey: key)
    }
    
    func fetchData<T: Codable>(_ model: T, for key: String) -> T? {
        
        if let postsData = userDefaults.object(forKey: key) as? Data,
            let model = try? JSONDecoder().decode(T.self, from: postsData) {
            
            return model
        }
        return nil
    }
}


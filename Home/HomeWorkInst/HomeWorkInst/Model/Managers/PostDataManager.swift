//
//  DataManager.swift
//  6HomeworkInstagram
//
//  Created by Роман Шуркин on 16/11/2019.
//  Copyright © 2019 Роман Шуркин. All rights reserved.
//

import Foundation
import UIKit

protocol DataProtocol {
    func syncSave(post: Post)
    func asyncSave(post: Post, completion: @escaping () -> Void)
    func syncGet(id: String) -> Post?
    func asyncGet(id: String, completion: @escaping (Post) -> Void)
    func syncGetAllOfUser(user: User) -> [Post]
    func asyncGetAllOfUser(user: User, completion: @escaping ([Post]) -> Void)
    func syncGetAll() -> [Post]
    func asyncGetAll(completion: @escaping ([Post]) -> Void)
    func syncRemove(id: String)
    func asyncRemove(id: String, completion: @escaping ([Post]) -> Void)
    func syncSearch(id: String)
    func asyncSearch(textOfSearch: String, completion: @escaping ([Post]) -> Void)
}

enum UserDefaultKeys {
    static let posts = "posts"
}

/// Data Manager of User
class PostDataManager: DataProtocol {

    static var shared = PostDataManager()
    
    var userDefaults = UserDefaults.standard
    
    var allPosts: [Post]

    private init() {
        
        let user: User = UserDataManager().getUser(nickname: "romash_only")
        
        allPosts = [
            Post(id: "0", image: "post1", text: "Hello", user: user, likes: 2, date: Date()),
            Post(id: "1", image: "post2", text: "Hai", user: user, likes: 2, date: Date()),
            Post(id: "2", image: "post3", text: "Good", user: user, likes: 2, date: Date()),
            Post(id: "3", image: "post4", text: "Very Bad", user: user, likes: 2, date: Date()),
        ]
        
        if (userDefaults.object(forKey: UserDefaultKeys.posts) as? Data) != nil {
            allPosts = getFromUserDefaults()
        }
        if (userDefaults.object(forKey: UserDefaultKeys.posts) as? Data) == nil {
            updateUserDefaults(posts: allPosts)
        }
        
    }
    
    func syncSave(post: Post) {
        allPosts.append(post)
        updateUserDefaults(posts: allPosts)
    }
    
    func asyncSave(post: Post, completion: @escaping () -> Void) {
        
        let operationQueue = OperationQueue()

        DispatchQueue.global(qos: .userInteractive).async {

            let operation = BlockOperation { [weak self] in

                self?.allPosts.append(post)
                self?.updateUserDefaults(posts: self!.allPosts)

                DispatchQueue.main.async { completion() }
            }

            operationQueue.addOperation(operation)
        }
    }
    
    func syncGet(id: String) -> Post? {
        return allPosts.filter {
            $0.id == id
        }.first
    }
    
    func asyncGet(id: String, completion: @escaping (Post) -> Void) {
        return
    }
    
    func syncGetAllOfUser(user: User) -> [Post] {
        
        print(getFromUserDefaults())
        allPosts = getFromUserDefaults()

        return reverse(array: allPosts.filter { $0.user.id == user.id })
    }
    
    func asyncGetAllOfUser(user: User, completion: @escaping ([Post]) -> Void) {
        
        let operationQueue = OperationQueue()

        DispatchQueue.global(qos: .userInteractive).async {

            let operation = BlockOperation { [weak self] in


                DispatchQueue.main.async { [weak self] in

                    if let posts = self?.reverse(array: (self?.allPosts.filter { $0.user.id == user.id })!) {
                        completion(posts)
                    }
                }
            }

            operationQueue.addOperation(operation)
        }
    }
    
    func syncGetAll() -> [Post] {
        return allPosts
    }
    
    func asyncGetAll(completion: @escaping ([Post]) -> Void) {
        
        let operationQueue = OperationQueue()

        DispatchQueue.global(qos: .userInteractive).async {

            let operation = BlockOperation { [weak self] in


                DispatchQueue.main.async { [weak self] in

                    if let posts = self?.allPosts {
                        completion(posts)
                    }
                }
            }

            operationQueue.addOperation(operation)
        }
    }
    
    func syncRemove(id: String) {
        
        allPosts.removeAll {
            $0.id == id
        }
        
        updateUserDefaults(posts: allPosts)
    }
    
    func asyncRemove(id: String, completion: @escaping ([Post]) -> Void) {
        
        let operationQueue = OperationQueue()

        DispatchQueue.global(qos: .userInteractive).async {

            let operation = BlockOperation { [weak self] in

                self?.allPosts.removeAll {
                    $0.id == id
                }
                
                self?.updateUserDefaults(posts: self!.allPosts)

                DispatchQueue.main.async { [weak self] in

                    if let posts = self?.allPosts {
                        completion(posts)
                    }
                }
            }

            operationQueue.addOperation(operation)
        }
    }
    
    func syncSearch(id: String) {
        return
    }
    
    func asyncSearch(textOfSearch: String, completion: @escaping ([Post]) -> Void) {
        
        let operationQueue = OperationQueue()
        
        DispatchQueue.global(qos: .userInteractive).async {
            let operation = BlockOperation { [weak self] in
                
                if let filterPosts = self?.allPosts.filter({ $0.text.lowercased().contains(textOfSearch.lowercased()) }) {
                    DispatchQueue.main.async {
                        completion(filterPosts)
                    }
                }
            }
            operationQueue.addOperation(operation)
        }
    }
    
    func getUIImage(name: String) -> UIImage {
     return UIImage(named: name) ?? UIImage()
    }
    
    func reverse(array: [Post]) -> [Post] {
        
        var reverseArray = array
        
        for index in 0...reverseArray.count {
            if index < reverseArray.count / 2 {
                let t = reverseArray[index]
                reverseArray[index] = reverseArray[reverseArray.count - index - 1]
                reverseArray[reverseArray.count - index - 1] = t
            }
            else {
                break
            }
        }
        return reverseArray
    }
    
    func getFromUserDefaults() -> [Post] {
        
        var posts: [Post] = []
        
        if let postsData = userDefaults.object(forKey: UserDefaultKeys.posts) as? Data {
              
            let decoder = JSONDecoder()
            
            let model = try? decoder.decode([Post].self, from: postsData)
            
            return model!
        }
        
        return posts
    }
    
    func updateUserDefaults(posts: [Post]) {
        let encoder = JSONEncoder()
        let jsonData = try! encoder.encode(posts)
        userDefaults.set(jsonData, forKey: UserDefaultKeys.posts)
    }

}

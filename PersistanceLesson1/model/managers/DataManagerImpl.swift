//
//  DataManagerImpl.swift
//  PersistanceLesson1
//
//  Created by Enoxus on 20/11/2019.
//  Copyright © 2019 Ildar Zalyalov. All rights reserved.
//

import Foundation

/// keys for userdefaults storage
fileprivate enum UserDefaultsKeys {
    /// main database key
    static let databaseKey = "database"
}

class DataManagerImpl: DataManager {
    
    /// singleton instance
    public static let shared = DataManagerImpl()
    
    /// main database
    private var database: [Post]
    /// userdefaults instance
    private var userDefaults = UserDefaults.standard
    
    /// initial database population
    private init() {
        
        if let databaseData = userDefaults.data(forKey: UserDefaultsKeys.databaseKey), let db = try? JSONDecoder().decode([Post].self, from: databaseData) as [Post] {
            
            database = db
        }
        else {
            database = []
            let randomTexts = ["sample text", "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", "another sick text"]
            let user = User(name: "sample text", description: "desc", avi: "avi")
            
            for i in 1 ..< 10 {
                database.append(Post(owner: user, pic: "pic\(i)", text: randomTexts.randomElement()!))
            }
            if let jsonData = try? JSONEncoder().encode(database) {
                userDefaults.set(jsonData, forKey: UserDefaultsKeys.databaseKey)
            }
        }
    }
    
    /// method that deletes passed post in the main thread synchronously
    /// - Parameter post: post that should be deleted
    func syncDelete(_ post: Post) {
        
        database.removeAll(where: { $0.id == post.id })
        if let jsonData = try? JSONEncoder().encode(database) {
            userDefaults.set(jsonData, forKey: UserDefaultsKeys.databaseKey)
        }
    }
    
    /// method that deletes passed post asynchronously
    /// - Parameter post: post that should be deleted
    /// - Parameter completion: completion block that is being called after deleting the post, provides the updated list of posts
    func asyncDelete(_ post: Post, completion: @escaping ([Post]) -> Void) {
        
        let operationQueue = OperationQueue()
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            let operation = BlockOperation { [weak self] in
                
                self?.database.removeAll(where: { $0.id == post.id })
                if let jsonData = try? JSONEncoder().encode(self?.database) {
                    self?.userDefaults.set(jsonData, forKey: UserDefaultsKeys.databaseKey)
                }
                
                DispatchQueue.main.async { [weak self] in
                    
                    if let db = self?.database {
                        completion(db)
                    }
                }
            }
            
            operationQueue.addOperation(operation)
        }
    }
    
    /// method that returns particular post syncronously
    /// - Parameter index: index of the post in database
    func syncGet(by index: Int) -> Post {
        return database[index]
    }
    
    /// method that returns particular post asyncronously
    /// - Parameter index: index of the post in database
    /// - Parameter completion: completion block that is being called after retrieving the post, provides this post as an input parameter
    func asyncGet(by index: Int, completion: @escaping (Post) -> Void) {
        
        let operationQueue = OperationQueue()
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            let operation = BlockOperation { [weak self] in
                
                if let post = self?.database[index] {
                    
                    DispatchQueue.main.async {
                        completion(post)
                    }
                }
            }
            
            operationQueue.addOperation(operation)
        }
    }
    
    /// method that synchronously returns whole database
    func syncGetAll() -> [Post] {
        return database
    }
    
    /// method that asynchronously returns whole database
    /// - Parameter completion: completion block that is being called after retrieving the database, provides its posts as an input parameter
    func asyncGetAll(completion: @escaping ([Post]) -> Void) {
        
        let operationQueue = OperationQueue()
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            let operation = BlockOperation { [weak self] in
                
                if let database = self?.database {
                    
                    DispatchQueue.main.async {
                        completion(database)
                    }
                }
            }
            
            operationQueue.addOperation(operation)
        }
    }
    
    /// method that asyncronously filters the database and returns posts that meet the criteria
    /// - Parameter query: string that should be contained in post's text
    /// - Parameter completion: completion block that is being called after filtering the database, provides filtered list as an input parameter
    func asyncSearch(by query: String, completion: @escaping ([Post]) -> Void) {
        
        let operationQueue = OperationQueue()
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            let operation = BlockOperation { [weak self] in
                
                if let searchResults = self?.database.filter({ $0.text.lowercased().contains(query.lowercased()) }) {
                    
                    DispatchQueue.main.async {
                        completion(searchResults)
                    }
                }
                else {
                    
                    DispatchQueue.main.async {
                        completion([])
                    }
                }
            }
            
            operationQueue.addOperation(operation)
        }
    }
    
    /// method that syncronously appends given post to database
    /// - Parameter post: the post to append
    func syncSave(_ post: Post) {
        database.append(post)
        if let jsonData = try? JSONEncoder().encode(database) {
            userDefaults.set(jsonData, forKey: UserDefaultsKeys.databaseKey)
        }
    }
    
    /// method that asyncronously appends given post to database
    /// - Parameter post: the post to append
    /// - Parameter completion: completion block that is being called after appending the post to database, provides updated list as an input parameter
    func asyncSave(_ post: Post, completion: @escaping ([Post]) -> Void) {
        
        let operationQueue = OperationQueue()
        DispatchQueue.global(qos: .userInteractive).async {
            
            let operation = BlockOperation { [weak self] in
                self?.database.append(post)
                if let jsonData = try? JSONEncoder().encode(self?.database) {
                    self?.userDefaults.set(jsonData, forKey: UserDefaultsKeys.databaseKey)
                }
            }
            
            DispatchQueue.main.async { [weak self] in
                
                if let db = self?.database {
                    completion(db)
                }
            }
            
            operationQueue.addOperation(operation)
        }
    }
}

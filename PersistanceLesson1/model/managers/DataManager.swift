//
//  DataManager.swift
//  PersistanceLesson1
//
//  Created by Enoxus on 20/11/2019.
//  Copyright © 2019 Ildar Zalyalov. All rights reserved.
//

import Foundation

protocol DataManager {
    
    func syncDelete(_ post: Post)
    func asyncDelete(_ post: Post, completion: @escaping ([Post]) -> Void)
    func syncGet(by index: Int) -> Post
    func asyncGet(by index: Int, completion: @escaping (Post) -> Void)
    func syncGetAll() -> [Post]
    func asyncGetAll(completion: @escaping ([Post]) -> Void)
    func asyncSearch(by query: String, completion: @escaping ([Post]) -> Void)
    func syncSave(_ post: Post)
    func asyncSave(_ post: Post, completion: @escaping ([Post]) -> Void)
}

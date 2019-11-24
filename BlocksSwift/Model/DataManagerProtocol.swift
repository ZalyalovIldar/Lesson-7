//
//  DataManagerProtocol.swift
//  BlocksSwift
//
//  Created by Евгений on 08.11.2019.
//  Copyright © 2019 Ildar Zalyalov. All rights reserved.
//

import Foundation

//Data Manager protocol
protocol DataManagerProtocol {
    
// MARK: - Saving methods
    func syncSave(_ post: Post) -> [Post]
    func asyncSave(_ post: Post, completion: @escaping ([Post]) -> Void)
    
// MARK: - Getting methods
    func syncGet() -> [Post]
    func asyncGet(completion: @escaping ([Post]) -> Void)
    
// MARK: - Deleting methods
    func syncDelete(_ post: Post) -> [Post]
    func asyncDelete(_ post: Post, completion: @escaping ([Post]) -> Void)
    
// MARK: - Searching methods
    func syncSearch(_ searchQuery: String) -> [Post]
    func asyncSearch(_ searchQuery: String, completion: @escaping ([Post]) -> Void)
    
}

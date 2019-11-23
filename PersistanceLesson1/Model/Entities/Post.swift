//
//  Post.swift
//  Threads
//
//  Created by Amir on 13.11.2019.
//  Copyright © 2019 Ildar Zalyalov. All rights reserved.
//

import UIKit

struct Post: Codable {
    
    let image: String!
    let description: String?
    let postId: String
    let time: String
    let likes: Int
    
    init(image: String!, description: String?, time: String!, likes: Int!) {
        
        self.image = image
        self.description = description
        self.time = time
        self.likes = likes
        
        postId = UUID().uuidString
    }
}

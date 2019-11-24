//
//  User.swift
//  BlocksSwift
//
//  Created by Евгений on 25.10.2019.
//  Copyright © 2019 Ildar Zalyalov. All rights reserved.
//

import Foundation

// Structure, that contains basic information about user
struct User {
    
    var name: String
    var nickName: String
    var profileImage: String
    var posts: [Post]
}

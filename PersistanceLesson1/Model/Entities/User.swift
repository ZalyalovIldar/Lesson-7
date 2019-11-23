//
//  User.swift
//  BlocksSwift
//
//  Created by Amir on 26.10.2019.
//  Copyright © 2019 Ildar Zalyalov. All rights reserved.
//

import UIKit

struct User: Codable {
    
    var nickName: String!
    var name: String!
    var profileImage: String!
    var posts: [Post]
}

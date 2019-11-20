//
//  User.swift
//  PersistanceLesson1
//
//  Created by Enoxus on 20/11/2019.
//  Copyright © 2019 Ildar Zalyalov. All rights reserved.
//

import Foundation

/// simple user model that contains name, description and avi image
struct User: Codable {
    
    let name: String
    let description: String
    let avi: String
}

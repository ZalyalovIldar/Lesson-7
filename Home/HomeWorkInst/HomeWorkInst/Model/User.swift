//
//  User.swift
//  6HomeworkInstagram
//
//  Created by Роман Шуркин on 18.11.2019.
//  Copyright © 2019 Роман Шуркин. All rights reserved.
//

import Foundation
import UIKit

/// Model of User
struct User: Codable {
    var id: String
    var nickname: String
    var avatarImage: String
    
}

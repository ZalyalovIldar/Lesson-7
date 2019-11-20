//
//  UserSettings.swift
//  PersistanceLesson1
//
//  Created by Ильдар Залялов on 20.11.2019.
//  Copyright © 2019 Ildar Zalyalov. All rights reserved.
//

import Foundation

class UserSettings: NSObject, NSCoding {
    
    var isAuthorized: Bool = false
    
    fileprivate enum UserSettings {
        static let isAuthorized = "isAuthorized"
    }
    
    init(authorized: Bool) {
        isAuthorized = authorized
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(isAuthorized, forKey: UserSettings.isAuthorized)
    }
    
    required init?(coder: NSCoder) {
        isAuthorized = coder.decodeBool(forKey: UserSettings.isAuthorized)
    }
}

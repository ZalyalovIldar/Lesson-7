//
//  UserDataManager.swift
//  6HomeworkInstagram
//
//  Created by Роман Шуркин on 18.11.2019.
//  Copyright © 2019 Роман Шуркин. All rights reserved.
//

import Foundation
import UIKit

///Data Manager of User
class UserDataManager {
    
    var userDefaults = UserDefaults.standard
        
    /// Method for getting User
    /// - Parameter nickname: nickname of User
    func getUser(nickname: String) -> User {
        
        if getFromUserDefaults() != nil {
            return getFromUserDefaults()!
        }
        else {
            updateUserDefaults(user: User(id: UUID().uuidString, nickname: "romash_only", avatarImage: "ava"))
            return getFromUserDefaults()!
        }
        
    }
    
    func updateUserDefaults(user: User) {
        let encoder = JSONEncoder()
        let jsonData = try! encoder.encode(user)
        userDefaults.set(jsonData, forKey: UserDefaultKeys.user)
    }
    
    func getFromUserDefaults() -> User? {
        
        if let userData = userDefaults.object(forKey: UserDefaultKeys.user) as? Data {
              
            let decoder = JSONDecoder()
            
            let model = try? decoder.decode(User.self, from: userData)
            
            return model!
        }
        
        return nil
    }
}

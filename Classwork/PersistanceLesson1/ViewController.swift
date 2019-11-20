//
//  ViewController.swift
//  PersistanceLesson1
//
//  Created by Ильдар Залялов on 20.11.2019.
//  Copyright © 2019 Ildar Zalyalov. All rights reserved.
//

import UIKit


enum UserDefaultKeys {
    static let userSetting = "userSetting"
    static let userSettingStruct = "userSettingStruct"
}

class ViewController: UIViewController {
    
    var userDefaults = UserDefaults.standard
    
    let keyForBool = "boolKey"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let settings = UserSettings(authorized: true)
        
        let settingsData = try? NSKeyedArchiver.archivedData(withRootObject: [settings, settings], requiringSecureCoding: false)
        
        userDefaults.set(settingsData, forKey: UserDefaultKeys.userSetting)
        
        ///Struct
        
        let encoder = JSONEncoder()
        let settingsStruct = UserSettingsStruct(isAuthorized: true)
        let jsonData = try! encoder.encode(settingsStruct)
        
        userDefaults.set(jsonData, forKey: UserDefaultKeys.userSettingStruct)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let userSettingsData = userDefaults.object(forKey: UserDefaultKeys.userSetting) as? Data,
            let userSettings = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(userSettingsData) as? [UserSettings] {
            
            print("Settings: \(userSettings)")
        }
        
        if let userSettingsData = userDefaults.object(forKey: UserDefaultKeys.userSettingStruct) as? Data {
              
            let decoder = JSONDecoder()
            
            guard let model = try? decoder.decode(UserSettingsStruct.self, from: userSettingsData) else { return }
            
            print("SettingsStruct: \(model)")
        }
        
    }
    
    //

}


//
//  UserDefaultValue.swift
//  DDPicEdit
//
//  Created by LongDengYu on 2023/4/13.
//

import UIKit

@propertyWrapper
struct UserDefaultValue<T> {
    var key: String
    var defaultValue: T
    
    init(wrappedValue: T, key: String) {
        self.key = key
        self.defaultValue = wrappedValue
    }
    
    var wrappedValue: T {
        get { UserDefaults.standard.object(forKey: self.key) as? T ?? self.defaultValue }
        set { UserDefaults.standard.set(newValue, forKey: self.key) }
    }
}

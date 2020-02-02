//
//  User.swift
//  RMRDevice
//
//  Created by Александр Востриков on 08.12.2019.
//  Copyright © 2019 Александр Востриков. All rights reserved.
//

import Foundation
import Firebase

struct User {
    let uid: String
    var name: String?
    var lastName: String?
    var displayName: String? {
        get {
            if let name = name {
                if let lastName = lastName {
                    return lastName + " " + name
                }
            }
            return nil
        }
        set {
            let displayName = newValue?.components(separatedBy: " ")
            guard let name = displayName?[1] else { return }
            guard let lastName = displayName?[0] else { return }
            self.name = name
            self.lastName = lastName
        }
    }
    //let lastName: String?
    let email: String?
    let admin: Bool? = false
    
//    init(user: Firebase.User) {
//        self.uid = user.uid
//        self.email = user.email
//    }
    init(user: Firebase.User) {
        self.uid = user.uid
        self.email = user.email
        self.displayName = user.displayName
        
    }
    
}

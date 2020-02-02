//
//  Models.swift
//  RMRDevice
//
//  Created by Александр Востриков on 08.12.2019.
//  Copyright © 2019 Александр Востриков. All rights reserved.
//

import Foundation
import Firebase

struct Device {
    
    let uid: String
    let name: String
    let year: String
    let os: String
    let user: User?
    let platform: String
    var isBusy: Bool = false
    let ref: DatabaseReference?
    
    
    init(uid: String, name: String, year: String, os: String, platform: String) {
        self.uid = uid
        self.name = name
        self.year = year
        self.os = os
        self.platform = platform
        self.ref = nil
        self.user = nil
        self.isBusy = false
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        uid = snapshotValue["uid"] as! String
        name = snapshotValue["name"] as! String
        year = snapshotValue["year"] as! String
        os = snapshotValue["os"] as! String
        platform = snapshotValue["platform"] as! String
        user = snapshotValue["user"] as? User
        isBusy = snapshotValue["isBusy"] as! Bool
        ref = snapshot.ref
    }
    
    func convertToDict() -> Any {
        ["uid": uid,
        "name": name,
        "year": year,
        "os": os,
        "platform": platform,
        "isBusy": isBusy]
    }
}

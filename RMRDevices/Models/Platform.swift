//
//  Platform.swift
//  RMRDevices
//
//  Created by Александр Востриков on 14.01.2020.
//  Copyright © 2020 Александр Востриков. All rights reserved.
//

import Foundation

enum Platform: String {
    case apple = "apple"
    case android = "android"
    
    init?(string: String) {
        switch string.lowercased() {
        case "apple": self = .apple
        case "android": self = .android
        default: return nil
        }
    }
    
}

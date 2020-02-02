//
//  HistroryViewController.swift
//  RMRDevices
//
//  Created by Александр Востриков on 14.01.2020.
//  Copyright © 2020 Александр Востриков. All rights reserved.
//

import UIKit
import Firebase

class HistroryViewController: UIViewController {
    
    var ref: DatabaseReference!
    
    @IBOutlet weak var adminLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adminLabel.isHidden = true
        ref = Database.database().reference(withPath: "users")
//        guard let currentUser = Auth.auth().currentUser else {
//            return
//        }
        //let userRef = self.ref.child(currentUser.uid)
        
    }
}

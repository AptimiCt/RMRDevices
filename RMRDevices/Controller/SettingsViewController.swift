//
//  SettingsViewController.swift
//  RMRDevices
//
//  Created by Александр Востриков on 08.01.2020.
//  Copyright © 2020 Александр Востриков. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {
    @IBOutlet weak var exitButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func exitTapped(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        }
        dismiss(animated: true, completion: nil)
    }
}

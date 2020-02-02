//
//  AddViewController.swift
//  RMRDevices
//
//  Created by Александр Востриков on 08.01.2020.
//  Copyright © 2020 Александр Востриков. All rights reserved.
//

import UIKit
import Firebase

class AddViewController: UIViewController {
    
    var user: User!
    var ref: DatabaseReference!
    var divices = Array<Device>()
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var osTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var platformTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        user = User(user: currentUser)
        ref = Database.database().reference(withPath: "devices")
        configureAddObserver()
    }
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let name = nameTextField.text, let os = osTextField.text, let year = yearTextField.text, let platform = platformTextField.text
        else {
            return
        }
        guard let key = ref.childByAutoId().key else { return }
        //print(key)
        let device = Device(uid: key, name: name, year: year, os: os, platform: platform)
        let devRef = self.ref.child(device.uid)
        devRef.setValue(device.convertToDict())
        self.navigationController?.popViewController(animated: true)
    }
}

//
//  RegisterViewController.swift
//  RMRDevices
//
//  Created by Александр Востриков on 08.01.2020.
//  Copyright © 2020 Александр Востриков. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    var ref: DatabaseReference!
    let segueIdentifier = "tabBarSegueAfterRegister"

    @IBOutlet weak var warnLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwodrTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        warnLabel.alpha = 0
        ref = Database.database().reference(withPath: "users")
        configureAddObserver()
        stateDidChangeListener()
    }
    
    func displayWarningLabel(withText text: String) {
        warnLabel.text = text
        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: { [weak self] in
            self?.warnLabel.alpha = 1
        }) { [weak self] comlite in
            self?.warnLabel.alpha = 0
        }
    }
    
    @IBAction func register(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwodrTextField.text, email != "", password != "" else {
            displayWarningLabel(withText: "Данные не корректны")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (user, error) in
            guard error == nil, user != nil else {
                print(error!.localizedDescription)
                return
            }
            let userRef = self?.ref.child((user?.user.uid)!)
            userRef?.setValue(["admin": false, "email": email, "device": nil])
            
        }
        
    }
    
    func stateDidChangeListener() {
        Auth.auth().addStateDidChangeListener { [weak self](auth, user) in
            if user != nil {
                self?.performSegue(withIdentifier: (self?.segueIdentifier)!, sender: nil)
            }
        }
    }
}

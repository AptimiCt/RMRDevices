//
//  ViewController.swift
//  RMRDevices
//
//  Created by Александр Востриков on 07.01.2020.
//  Copyright © 2020 Александр Востриков. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    let segueIdentifier = "tabBarSegue"
    var isAdmin = false
    
    @IBOutlet weak var warnLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwodrTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        warnLabel.alpha = 0
        let check = isAdminCheck()

        //Настройка отслеживания поднятия клавиатуры
        configureAddObserver()
        
    }
    
//    MARK: - viewWillAppear, очистка данных для входа
    
    override func viewWillAppear(_ animated: Bool) {
        emailTextField.text = ""
        passwodrTextField.text = ""
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == segueIdentifier) {

            let custMainVC = segue.destination as! UITabBarController
            let res = custMainVC.viewControllers?[0] as! UINavigationController
            let navController =  res.topViewController  as! DeviceViewController
            navController.isAdmin = isAdmin
        }
    }
    
        func isAdminCheck() -> Bool {
            guard let currentUser = Auth.auth().currentUser else {
                return false
            }
            Database.database().reference(withPath: "users").child(currentUser.uid).observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
    
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    self?.isAdmin = dictionary["admin"] as! Bool
                }
                print("Compition admin: \(String(describing: self?.isAdmin))")
            }, withCancel: nil)
            return true
        }

    func stateDidChangeListener(_ check: Bool) {
        
        while !check {
            
            Auth.auth().addStateDidChangeListener { [weak self](auth, user) in
                if user != nil {
                    self?.performSegue(withIdentifier: (self?.segueIdentifier)!, sender: nil)
                }
            }
        }
    }
    
    func displayWarningLabel(withText text: String) {
        warnLabel.text = text
        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: { [weak self] in
            self?.warnLabel.alpha = 1
        }) { [weak self] comlite in
            self?.warnLabel.alpha = 0
        }
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        guard let email = emailTextField?.text, let password = passwodrTextField?.text, email != "", password != "" else {
            displayWarningLabel(withText: "Данные не корректны")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { [weak self](user, error) in
            
            if error != nil {
                self?.displayWarningLabel(withText: "Ошибка")
                return
            }
            if user != nil {
                self?.performSegue(withIdentifier: "tabBarSegue", sender: nil)
                return
            }
            self?.displayWarningLabel(withText: "Нет такого пользователя")
        }
        
    }
    
    @IBAction func registerTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "registerSegue", sender: nil)
    }
}

// MARK: - extension UIViewController
extension UIViewController {
    @objc func kbDidShow(notification: Notification){
        guard let userInfo = notification.userInfo else { return }
        let kbFrameSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        (self.view as! UIScrollView).contentSize = CGSize(width: self.view.bounds.size.width,
                                                          height: self.view.bounds.size.height + kbFrameSize.height)
        (self.view as! UIScrollView).scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbFrameSize.height, right: 0)
    }
    @objc func kbDidHide(){
        (self.view as! UIScrollView).contentSize = CGSize(width: self.view.bounds.size.width,
                                                          height: self.view.bounds.size.height)
    }
    
    func configureAddObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(kbDidShow),
                                               name: UIResponder.keyboardDidShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(kbDidHide),
                                               name: UIResponder.keyboardDidHideNotification,
                                               object: nil)
    }
}

//
//  DeviceViewController.swift
//  RMRDevices
//
//  Created by Александр Востриков on 07.01.2020.
//  Copyright © 2020 Александр Востриков. All rights reserved.
//

import UIKit
import Firebase

class DeviceViewController: UIViewController {
    
    var user: User!
    var isAdmin = false
    var search: UISearchController!

    var ref: DatabaseReference!
    var devices = Array<Device>()
    var searchResults:[Device] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        //поиск
        let search = UISearchController(searchResultsController: self)
        search.searchResultsUpdater = self
        //self.navigationItem.searchController = search
    
        ref = Database.database().reference(withPath: "devices")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ref.observe(.value, with: { [weak self] (snapshot) in
            var _devices = Array<Device>()
            for item in snapshot.children {
                let device = Device(snapshot: item as! DataSnapshot)
                _devices.append(device)
            }
            self?.devices = _devices
            self?.tableView.reloadData()
        })
    }
    
    @IBAction func exitTapped(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        }
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Свайпы на ячейках
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let cell = tableView.cellForRow(at: indexPath) as! TableViewCell
        
        let toFree = UIContextualAction(style: .normal, title: "Осовбодить") { [weak self] (action, view, success) in
            tableView.cellForRow(at: indexPath)?.backgroundColor = .clear
            cell.labelInfo.isHidden = true
            cell.userName.isHidden = true
            self?.ref.child(cell.uid).child("isBusy").setValue(false)
            self?.ref.child(cell.uid).child("username").setValue(nil)
            tableView.reloadData()
        }
        toFree.image = UIImage(systemName: "arrowshape.turn.up.right")
        toFree.backgroundColor = #colorLiteral(red: 0, green: 0.785775125, blue: 0, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [toFree])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let pickUp = UIContextualAction(style: .normal, title: "Забрать") { [weak self] (action, view, success) in
            self?.allert(indexPath)
        }
        pickUp.image = UIImage(systemName: "arrowshape.turn.up.left")
        pickUp.backgroundColor = #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1)
        return UISwipeActionsConfiguration(actions: [pickUp])
    }
    
    func allert(_ indexPath: IndexPath) {
        let alert = UIAlertController(title: "Пользователь", message: "", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (_) -> Void in
            }
        let saveAction = UIAlertAction(title: "Save", style: .default) { (_) -> Void in
                let textField = alert.textFields?[0]
                if let tf = textField {
                    if let text = tf.text {
                        self.updateUser(text: text, indexPath)
                    }
                }
            }
            
        alert.addTextField { (_) -> Void in
                
            }
            alert.addAction(cancelAction)
            alert.addAction(saveAction)
            
        self.present(alert, animated: true, completion: nil)
        }
    
    func updateUser(text: String, _ indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TableViewCell
        self.ref.child(cell.uid).child("isBusy").setValue(true)
        self.ref.child(cell.uid).child("username").setValue(text)
        cell.labelInfo.isHidden = false
        cell.userName.isHidden = false
        tableView.cellForRow(at: indexPath)?.backgroundColor = #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1)
    }
    
    func addUser(_ ref: DatabaseReference,_ text: String, _ indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TableViewCell
        ref.child(cell.uid).child("username").setValue(text)
    }
}

extension DeviceViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        cell.nameDevice.text = devices[indexPath.row].name
        let uidD = devices[indexPath.row].uid
        cell.uid = uidD
        let userName = devices[indexPath.row].username
        let deviceOs = devices[indexPath.row].os
        let isBusy = devices[indexPath.row].isBusy
        print("isBusy:\(isBusy)")
        //print("userName:\(userName)")
        cell.backgroundColor = .clear
        if isBusy {
            cell.backgroundColor = .red
            cell.userName.text = userName
        } else {
            cell.labelInfo.isHidden = true
            cell.userName.isHidden = true
        }
        if true {
            cell.imageViewCell.image = UIImage(named: "logo")
        }
        cell.osDevice?.text = deviceOs
        
        cell.nameDevice.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        cell.osDevice.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        cell.labelInfo.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        cell.userName.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func filterContent(for searchText: String) {
        searchResults = devices.filter({ (device) -> Bool in
            let name = device.name
            let isMatch = name.localizedCaseInsensitiveContains(searchText)
            if isMatch {
                return true
            } else {
                return false
            }
        })
    }
}

extension DeviceViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContent(for: searchText)
            self.tableView.reloadData()
        }
    }
    
    func filterContentForSearchText(_ searchText: String) {
        var filteredDevice =  devices.filter({ (device: Device) -> Bool in
            return device.name.lowercased().contains(searchText.lowercased())
        })
    }
    
}

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
        self.navigationItem.searchController = search
    
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
    
    //Свайпы по на ячейках
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let toFree = UIContextualAction(style: .normal, title: "Осовбодить") { (action, view, success) in
            tableView.cellForRow(at: indexPath)?.backgroundColor = .clear
            print("Осовбождено: \(action)")
        }
        toFree.image = UIImage(systemName: "arrowshape.turn.up.right")
        toFree.backgroundColor = .clear
        return UISwipeActionsConfiguration(actions: [toFree])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let pickUp = UIContextualAction(style: .normal, title: "Забрать") { [weak self] (action, view, success) in
            self?.allert(indexPath)
            print("Занято")
            
        }
        pickUp.image = UIImage(systemName: "arrowshape.turn.up.left")
        pickUp.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
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
                        self.updateUser(text: text, indexPath )
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
        tableView.cellForRow(at: indexPath)?.backgroundColor = .red
    }
    
    func configureActions(for admin: Bool) {
        print("admin of action: \(admin)")
        if !admin {
            addButton.isEnabled = false
        }
    }
    
    @IBAction func exitTapped(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        }
        dismiss(animated: true, completion: nil)
    }
    
}

extension DeviceViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
        
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let deviceName = devices[indexPath.row].name
        let deviceOs = devices[indexPath.row].os
        var isBusy = devices[indexPath.row].isBusy
        
        cell.backgroundColor = .clear
        if isBusy {
            cell.backgroundColor = .red
        }
        cell.textLabel?.text = deviceName
        cell.detailTextLabel?.text = deviceOs
        cell.textLabel?.textColor = .white
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

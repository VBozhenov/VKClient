//
//  MyGroupsController.swift
//  VKClient
//
//  Created by Vladimir Bozhenov on 23/12/2018.
//  Copyright © 2018 Vladimir Bozhenov. All rights reserved.
//

import UIKit
import Kingfisher
import RealmSwift
import FirebaseDatabase
import FirebaseAuth

class MyGroupsController: UITableViewController {
    
    var groups: Results<Group>?
    var mySearchedGroups: Results<Group>?
    var allSearchedGroups = [Group]()
    
    let networkService = NetworkService()
    let dataService = DataService()
    var notificationToken: NotificationToken?
    
    private var firebaseUsers = [FirebaseUser]()
    private let ref = Database.database().reference(withPath: "users")
    
    let searchController = UISearchController(searchResultsController: nil)
    
    let throttler = Throttler(minimumDelay: 0.5)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Groups"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        networkService.loadGroups() { [weak self] groups, error in
            if let error = error {
                print(error.localizedDescription)
                return
            } else if let groups = groups?.filter ({$0.name != ""}),
                let self = self {
                self.dataService.saveGroups(groups)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        pairTableAndRealm()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        notificationToken?.invalidate()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return isFiltering() ? 2 : 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if isFiltering() {
                guard let mySearchedGroups = mySearchedGroups else { return 0 }
                return mySearchedGroups.count
            } else {
                guard let groups = groups else { return 0 }
                return groups.count
            }
        } else {
            return allSearchedGroups.count
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 1 ? "Global search" : nil
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyGroups", for: indexPath) as! MyGroupsCell
        
        let group: String
        let groupAvatar = UIImageView()
        
        if indexPath.section == 0 {
            if isFiltering() {
                guard let mySearchedGroups = mySearchedGroups else { return UITableViewCell() }
                group = mySearchedGroups[indexPath.row].name
                if let photo = mySearchedGroups[indexPath.row].photo {
                    groupAvatar.kf.setImage(with: URL(string: photo))
                }
            } else {
                guard let groups = groups else { return UITableViewCell() }
                group = groups[indexPath.row].name
                if let photo = groups[indexPath.row].photo {
                    groupAvatar.kf.setImage(with: URL(string: photo))
                }
            }
        } else {
            group = allSearchedGroups[indexPath.row].name
            if let photo = allSearchedGroups[indexPath.row].photo {
                groupAvatar.kf.setImage(with: URL(string: photo))
            }
        }
        
        cell.myGroupLabel.text = group

        let border = UIView()
        border.frame = cell.myGroupAvatar.bounds
        border.layer.cornerRadius = cell.myGroupAvatar.bounds.height / 2
        border.layer.masksToBounds = true
        cell.myGroupAvatar.addSubview(border)

        groupAvatar.frame = border.bounds
        border.addSubview(groupAvatar)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        var action = UITableViewRowAction()
        
        if indexPath.section == 0 {
            
            action = UITableViewRowAction(style: .destructive, title: "Delete") {
                _, indexPath in
                var groupId = 0
                if self.isFiltering() {
                    guard let mySearchedGroups = self.mySearchedGroups else { return }
                    groupId = mySearchedGroups[indexPath.row].id
                    self.dataService.deleteGroup(groupId: groupId)
                } else {
                    guard let groups = self.groups else { return }
                    groupId = groups[indexPath.row].id
                    self.dataService.deleteGroup(groupId: groupId)
                }
                self.networkService.leaveGroup(with: groupId)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        } else {
            
            action = UITableViewRowAction(style: .default, title: "Add") {
                _, indexPath in
                
                let alertController = UIAlertController(
                    title: "Do you want to add\n \(self.allSearchedGroups[indexPath.row].name)?",
                    message: nil,
                    preferredStyle: .alert)
                let alertButtonOne = UIAlertAction(title: "ОК", style: .default) { (action:UIAlertAction) in
                    let groupId = self.allSearchedGroups[indexPath.row].id
                    let groupsId = [Int]()
                    if !groupsId.contains(groupId) {
                        self.networkService.joinGroup(with: groupId)
                        let groupAdded = self.allSearchedGroups[indexPath.row]
                        self.dataService.addGroup(group: groupAdded)
                        self.searchController.isActive = true
                        self.addedGroupsHistoryToFirebase(group: groupAdded)
                    }
                }
                
                let alertButtonTwo = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                
                alertController.addAction(alertButtonOne)
                alertController.addAction(alertButtonTwo)
                self.present(alertController, animated: true, completion: nil)
            }
            
            action.backgroundColor = UIColor.blue
        }
        
        return [action]
    }

    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        
        networkService.searchGroups(searchText) { [weak self] groups, error in
            if let error = error {
                print(error.localizedDescription)
                return
            } else if let groups = groups,
                let self = self {
                self.allSearchedGroups = groups
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
        mySearchedGroups = groups?.filter("name CONTAINS[cd] %@", searchText)
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func pairTableAndRealm() {
        guard let realm = try? Realm() else { return }
        groups = realm.objects(Group.self)
        notificationToken = groups?.observe ({ [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
                self?.updateSearchResults(for: (self?.searchController)!)
            case .update:
                tableView.reloadData()
                self?.updateSearchResults(for: (self?.searchController)!)
            case .error(let error):
                fatalError("\(error)")
            }
        })
    }
    
    func addedGroupsHistoryToFirebase (group: Group) {
        self.ref.child("\(String(Session.user.userID))/groupsAdded").updateChildValues([String(group.id): group.name])
    }
    
    func addedSearchHistoryToFirebase (searchText: String) {
        self.ref.child("\(String(Session.user.userID))/searchHistory").updateChildValues([String(format: "%0.f", Date().timeIntervalSince1970): searchText])
    }
    
}

extension MyGroupsController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        throttler.throttle {
            self.filterContentForSearchText(searchController.searchBar.text!)
            if self.isFiltering() && (searchController.searchBar.text!.count > 3) {
                self.addedSearchHistoryToFirebase(searchText: searchController.searchBar.text!)
            }
        }
    }
}

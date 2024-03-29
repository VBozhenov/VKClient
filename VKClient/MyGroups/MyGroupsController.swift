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

class MyGroupsController: UITableViewController {
    
    var groups: Results<Group>?
    var mySearchedGroups: Results<Group>?
    var allSearchedGroups = [Group]()
    
    let groupsNetworkService = GroupsNetworkService()
    let dataService = DataService()
    var notificationToken: NotificationToken?
    
    let searchController = UISearchController(searchResultsController: nil)
    
    let throttler = Throttler(minimumDelay: 0.5)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Groups"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        groupsNetworkService.loadGroups() { [weak self] groups, error in
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
        
        if indexPath.section == 0 {
            if isFiltering() {
                guard let mySearchedGroups = mySearchedGroups else { return UITableViewCell() }
                group = mySearchedGroups[indexPath.row].name
                if let photo = mySearchedGroups[indexPath.row].photo {
                    RoundedAvatarWithShadow.roundAndShadow(sourceAvatar: photo,
                                                           destinationAvatar: cell.myGroupAvatar)
                }
            } else {
                guard let groups = groups else { return UITableViewCell() }
                group = groups[indexPath.row].name
                if let photo = groups[indexPath.row].photo {
                    RoundedAvatarWithShadow.roundAndShadow(sourceAvatar: photo,
                                                           destinationAvatar: cell.myGroupAvatar)
                }
            }
        } else {
            group = allSearchedGroups[indexPath.row].name
            if let photo = allSearchedGroups[indexPath.row].photo {
                RoundedAvatarWithShadow.roundAndShadow(sourceAvatar: photo,
                                                       destinationAvatar: cell.myGroupAvatar)
            }
        }
        
        cell.myGroupLabel.text = group
        
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
                self.groupsNetworkService.groupLeaveJoin(action: .leaveGroup, with: groupId)
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
                        self.groupsNetworkService.groupLeaveJoin(action: .joinGroup, with: groupId)
                        let groupAdded = self.allSearchedGroups[indexPath.row]
                        self.dataService.addGroup(group: groupAdded)
                        self.searchController.isActive = true
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
        
        groupsNetworkService.searchGroups(searchText) { [weak self] groups, error in
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
    
    func pairTableAndRealm(config: Realm.Configuration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)) {
        guard let realm = try? Realm(configuration: config) else { return }
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
}

extension MyGroupsController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        throttler.throttle {
            self.filterContentForSearchText(searchController.searchBar.text!)
        }
    }
}

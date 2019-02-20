//
//  MyGroupsController.swift
//  VKClient
//
//  Created by Vladimir Bozhenov on 23/12/2018.
//  Copyright © 2018 Vladimir Bozhenov. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class MyGroupsController: UITableViewController {
    
    var groups = [Group]()
    var mySearchedGroups = [Group]()
    var allSearchedGroups = [Group]()
    
    let networkService = NetworkService()
    
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
            } else if let groups = groups, let self = self {
                self.groups = groups.filter {$0.name != ""}
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return isFiltering() ? 2 : 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return isFiltering() ? mySearchedGroups.count : groups.count
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
                group = mySearchedGroups[indexPath.row].name
                if let photo = mySearchedGroups[indexPath.row].photo {
                    groupAvatar.kf.setImage(with: URL(string: photo))
                }
            } else {
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
                    groupId = self.mySearchedGroups[indexPath.row].id
                    for group in self.groups {
                        if group.id == groupId {
                            let index = self.groups.index(of: group)
                            self.groups.remove(at: index!)
                        }
                    }
                    self.mySearchedGroups.remove(at: indexPath.row)
                } else {
                    groupId = self.groups[indexPath.row].id
                    self.groups.remove(at: indexPath.row)
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
                    var groupsId = [Int]()
                    for group in self.groups {
                        groupsId.append(group.id)
                    }
                    if !groupsId.contains(groupId) {
                        self.networkService.joinGroup(with: groupId)
                        self.groups.append(self.allSearchedGroups[indexPath.row])
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
        
        mySearchedGroups = groups.filter({( group ) -> Bool in
            return group.name.lowercased().contains(searchText.lowercased())
        })
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
}

extension MyGroupsController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        throttler.throttle {
            self.filterContentForSearchText(searchController.searchBar.text!)
        }
    }
}

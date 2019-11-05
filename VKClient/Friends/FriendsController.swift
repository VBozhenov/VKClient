//
//  FriendsController.swift
//  VKClient
//
//  Created by Vladimir Bozhenov on 24/12/2018.
//  Copyright © 2018 Vladimir Bozhenov. All rights reserved.
//

import UIKit
import RealmSwift

class FriendsController: UITableViewController {
    
    var users: [User]? = []
    var mySearchedUsers: [User]? = []
    var filteredFriends: [User]? = []
    let friendsAdapter = FriendsAdapter()

    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Names"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        friendsAdapter.getFriends() { [weak self] users in
          self?.users = users
          self?.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if isFiltering() {
            guard let mySearchedUsers = mySearchedUsers else { return 0 }
            return firstLetters(in: mySearchedUsers).count
        } else {
            guard let users = users else { return 0 }
            return firstLetters(in: users).count
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            guard let mySearchedUsers = mySearchedUsers else { return 0 }
            return filterUsers(from: mySearchedUsers,
                               in: section).count
        } else {
            guard let users = users else { return 0 }
            return filterUsers(from: users,
                               in: section).count
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            titleForHeaderInSection section: Int) -> String? {
        if isFiltering() {
            guard let mySearchedUsers = mySearchedUsers else { return nil }
            return firstLetters(in:
                mySearchedUsers)[section]
        } else {
            guard let users = users else { return nil }
            return firstLetters(in: users)[section]
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsCell",
                                                 for: indexPath) as! FriendsCell
        
        if isFiltering() {
            guard let mySearchedUsers = mySearchedUsers else { return UITableViewCell() }
            filteredFriends = filterUsers(from: mySearchedUsers,
                                          in: indexPath.section)
        } else {
            guard let users = users else { return UITableViewCell() }
            filteredFriends = filterUsers(from: users,
                                          in: indexPath.section)
        }
        
        guard let filteredFriends = filteredFriends else { return UITableViewCell() }
        cell.friendNameLabel.text = filteredFriends[indexPath.row].lastName + " " + filteredFriends[indexPath.row].firstName
        
        if let avatar = filteredFriends[indexPath.row].avatar {
            RoundedAvatarWithShadow.roundAndShadow(sourceAvatar: avatar,
                                                   destinationAvatar: cell.friendAvatar)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let animationOne = CASpringAnimation(keyPath: "transform.scale")
        animationOne.fromValue = 0.5
        animationOne.toValue = 1
        animationOne.stiffness = 200
        animationOne.mass = 2
        animationOne.duration = 1
        animationOne.beginTime = CACurrentMediaTime()
        animationOne.fillMode = CAMediaTimingFillMode.backwards
        
        let animationTwo = CABasicAnimation(keyPath: "opacity")
        animationTwo.beginTime = CACurrentMediaTime()
        animationTwo.fromValue = 0
        animationTwo.toValue = 1
        animationTwo.duration = 2
        
        cell.layer.add(animationOne, forKey: nil)
        cell.layer.add(animationTwo, forKey: nil)
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if isFiltering() {
            guard let mySearchedUsers = mySearchedUsers else { return nil }
            return firstLetters(in:
                mySearchedUsers)
        } else {
            guard let users = users else { return nil }
            return firstLetters(in: users)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowFoto" {
            let friendFotoController = segue.destination as! FriendFotoController
            if let indexPath = self.tableView.indexPathForSelectedRow {
                if isFiltering() {
                    guard let mySearchedUsers = mySearchedUsers else { return }
                    filteredFriends = filterUsers(from: mySearchedUsers,
                                                  in: indexPath.section)
                } else {
                    guard let users = users else { return }
                    filteredFriends = filterUsers(from: users,
                                                  in: indexPath.section)
                }
                guard let filteredFriends = self.filteredFriends else { return }
                friendFotoController.friendId = filteredFriends[indexPath.row].id
                friendFotoController.friendName = filteredFriends[indexPath.row].lastName + " " + filteredFriends[indexPath.row].firstName
            }
        }
    }
    
    func filterUsers (from users: [User],
                      in section: Int) -> [User] {
        let key = firstLetters(in: users)[section]
        return users.filter { $0.lastName.first == key.first }
    }
 
    func firstLetters (in users: [User]) -> [String] {
        var firstLetters = [String]()
        for user in users {
            firstLetters.append(String(user.lastName.first!))
        }
        return Array(Set(firstLetters)).sorted()
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        
        mySearchedUsers = users?.filter { $0.lastName.contains(searchText) || $0.firstName.contains(searchText) }
        
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
}

extension FriendsController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

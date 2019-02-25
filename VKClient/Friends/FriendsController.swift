//
//  FriendsController.swift
//  VKClient
//
//  Created by Vladimir Bozhenov on 24/12/2018.
//  Copyright © 2018 Vladimir Bozhenov. All rights reserved.
//

import UIKit
import Kingfisher
import RealmSwift

class FriendsController: UITableViewController {
    
    var users = [User]()
    var mySearchedUsers = [User]()
    var allSearchedUsers = [User]()
    
    let networkService = NetworkService()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Names"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        networkService.loadFriends() { [weak self] users, error in
            if let error = error {
                print(error.localizedDescription)
                return
            } else if let users = users, let self = self {
                self.users = users.filter {$0.lastName != ""}
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
        let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        let realm = try! Realm(configuration: config)
        users = Array(realm.objects(User.self))
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return isFiltering() ? firstLetters(in: mySearchedUsers).count : firstLetters(in: users).count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering() ? filterUsers(from: mySearchedUsers, in: section).count : filterUsers(from: users, in: section).count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return isFiltering() ? firstLetters(in: mySearchedUsers)[section] : firstLetters(in: users)[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsCell", for: indexPath) as! FriendsCell
        
        let friendAvatar = UIImageView()
        var filteredFriends = [User]()
        
        filteredFriends = isFiltering() ? filterUsers(from: mySearchedUsers, in: indexPath.section) : filterUsers(from: users, in: indexPath.section)
        
        cell.friendNameLabel.text = filteredFriends[indexPath.row].lastName + " " + filteredFriends[indexPath.row].firstName
        
        let border = UIView()
        border.frame = cell.friendAvatar.bounds
        border.layer.cornerRadius = cell.friendAvatar.bounds.height / 2
        border.layer.masksToBounds = true
        cell.friendAvatar.addSubview(border)
        
        if let avatar = filteredFriends[indexPath.row].avatar {
            friendAvatar.kf.setImage(with: URL(string: avatar))
        }
        
        friendAvatar.frame = border.bounds
        border.addSubview(friendAvatar)
        
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
        return isFiltering() ? firstLetters(in: mySearchedUsers) : firstLetters(in: users)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowFoto" {
            let friendFotoController = segue.destination as! FriendFotoController
            if let indexPath = self.tableView.indexPathForSelectedRow {
                var filteredFriends = [User]()
                filteredFriends = isFiltering() ? filterUsers(from: mySearchedUsers ,in: indexPath.section) : filterUsers(from: users ,in: indexPath.section)
                friendFotoController.friendId = filteredFriends[indexPath.row].id
                friendFotoController.friendName = filteredFriends[indexPath.row].lastName + " " + filteredFriends[indexPath.row].firstName
            }
        }
    }
    
    func filterUsers (from users: [User], in section: Int) -> [User] {
        let key = firstLetters(in: users)[section]
        return users.filter { $0.lastName.first! == Character(key) }
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
        
        mySearchedUsers = users.filter({( name ) -> Bool in
            return name.lastName.lowercased().contains(searchText.lowercased()) || name.firstName.lowercased().contains(searchText.lowercased())
        })
        
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

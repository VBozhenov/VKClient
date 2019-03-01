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
    
    var users: Results<User>?
    var mySearchedUsers: Results<User>?
    
    let networkService = NetworkService()
    let dataService = DataService()
    var notificationToken: NotificationToken?

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
            } else if let users = users?.filter({$0.lastName != ""}),
                let self = self {

//                self.dataService.saveData(users)
                self.dataService.saveUsers(users)
            }
        }
        
        pairTableAndRealm()
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            guard let mySearchedUsers = mySearchedUsers else { return 0 }
            return filterUsers(from: mySearchedUsers, in: section).count
        } else {
            guard let users = users else { return 0 }
            return filterUsers(from: users, in: section).count
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isFiltering() {
            guard let mySearchedUsers = mySearchedUsers else { return nil }
            return firstLetters(in: mySearchedUsers)[section]
        } else {
            guard let users = users else { return nil }
            return firstLetters(in: users)[section]
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsCell", for: indexPath) as! FriendsCell
        
        let friendAvatar = UIImageView()
        var filteredFriends: Results<User>
        
        if isFiltering() {
            guard let mySearchedUsers = mySearchedUsers else { return UITableViewCell() }
            filteredFriends = filterUsers(from: mySearchedUsers, in: indexPath.section)
        } else {
            guard let users = users else { return UITableViewCell() }
            filteredFriends = filterUsers(from: users, in: indexPath.section)
        }
        
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
//        }
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
            return firstLetters(in: mySearchedUsers)
        } else {
            guard let users = users else { return nil }
            return firstLetters(in: users)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowFoto" {
            let friendFotoController = segue.destination as! FriendFotoController
            if let indexPath = self.tableView.indexPathForSelectedRow {
                var filteredFriends: Results<User>
                if isFiltering() {
                    guard let mySearchedUsers = mySearchedUsers else { return }
                    filteredFriends = filterUsers(from: mySearchedUsers ,in: indexPath.section)
                } else {
                    guard let users = users else { return }
                    filteredFriends = filterUsers(from: users ,in: indexPath.section)
                }
                friendFotoController.friendId = filteredFriends[indexPath.row].id
                friendFotoController.friendName = filteredFriends[indexPath.row].lastName + " " + filteredFriends[indexPath.row].firstName
            }
        }
    }
    
    func filterUsers (from users: Results<User>, in section: Int) -> Results<User> {
        let key = firstLetters(in: users)[section]
        return users.filter("lastName BEGINSWITH %@", key)
    }
 
    func firstLetters (in users: Results<User>) -> [String] {
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
        
        mySearchedUsers = users?.filter("lastName CONTAINS[cd] %@ OR firstName CONTAINS[cd] %@", searchText, searchText)
        
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
        
    func pairTableAndRealm() {
        guard let realm = try? Realm() else { return }
        users = realm.objects(User.self)
        notificationToken = users?.observe ({ [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update:
                tableView.reloadData()
            case .error(let error):
                fatalError("\(error)")
            }
        })
    }
}

extension FriendsController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

//
//  FriendsController.swift
//  VKClient
//
//  Created by Vladimir Bozhenov on 24/12/2018.
//  Copyright © 2018 Vladimir Bozhenov. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

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
                self.users = users
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        if isFiltering() {
            return firstLetters(in: mySearchedUsers).count
        } else {
            return firstLetters(in: users).count

        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering() {
            return filterUsers(from: mySearchedUsers, in: section).count
        } else {
            return filterUsers(from: users, in: section).count
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        if isFiltering() {
            return firstLetters(in: mySearchedUsers)[section]
        } else {
            return firstLetters(in: users)[section]
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsCell", for: indexPath) as! FriendsCell
        
        let friendAvatar = UIImageView()
        var filteredFriends = [User]()
        
        if isFiltering() {
            filteredFriends = filterUsers(from: mySearchedUsers, in: indexPath.section)
        } else {
            filteredFriends = filterUsers(from: users, in: indexPath.section)
        }
        cell.friendNameLabel.text = filteredFriends[indexPath.row].lastName + " " + filteredFriends[indexPath.row].firstName

        let border = UIView()
        border.frame = cell.friendAvatar.bounds
        border.layer.cornerRadius = cell.friendAvatar.bounds.height / 2
        border.layer.masksToBounds = true
        cell.friendAvatar.addSubview(border)

        friendAvatar.kf.setImage(with: URL(string: filteredFriends[indexPath.row].avatar))

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
    
    /* 
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if isFiltering() {
            return firstLetters(in: mySearchedUsers)
        } else {
            return firstLetters(in: users)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowFoto" {
            let friendFotoController = segue.destination as! FriendFotoController
            if let indexPath = self.tableView.indexPathForSelectedRow {
                var filteredFriends = [User]()
                if isFiltering() {
                    filteredFriends = filterUsers(from: mySearchedUsers ,in: indexPath.section)
                } else {
                    filteredFriends = filterUsers(from: users ,in: indexPath.section)
                }
                friendFotoController.friendId = filteredFriends[indexPath.row].id
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

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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//         self.navigationItem.rightBarButtonItem = self.editButtonItem
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let alertController = UIAlertController(
                title: "Do you want to add \(allSearchedGroups[indexPath.row].name)?",
                message: nil,
                preferredStyle: .alert)
            let alertButtonOne = UIAlertAction(title: "ОК", style: .default) { (action:UIAlertAction) in
                let groupId = self.allSearchedGroups[indexPath.row].id
                self.networkService.joinGroup(with: groupId)
                self.groups.append(self.allSearchedGroups[indexPath.row])
                tableView.reloadData()
            }
            let alertButtonTwo = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
            alertController.addAction(alertButtonOne)
            alertController.addAction(alertButtonTwo)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if editingStyle == .delete {
                let groupId = groups.remove(at: indexPath.row).id
                networkService.leaveGroup(with: groupId)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 1 ? false : true
    }
    
    
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
        
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
}

extension MyGroupsController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

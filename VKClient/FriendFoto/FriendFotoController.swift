//
//  FriendFotoController.swift
//  VKClient
//
//  Created by Vladimir Bozhenov on 24/12/2018.
//  Copyright © 2018 Vladimir Bozhenov. All rights reserved.
//

import UIKit
import Kingfisher
import RealmSwift

class FriendFotoController: UICollectionViewController {
    
    var friendId = 0
    var friendName = ""
    var indexPathForPushedPhoto = IndexPath()
    var photos: Results<Photo>?
    
    let utilityNetworkService = UtilityNetworkService()
    let friendsNetworkService = FriendsNetworkService()
    let dataService = DataService()
    
    var notificationToken: NotificationToken?
    
    @IBAction func fotoButtonPushed(_ sender: UIButton) {
        indexPathForPushedPhoto = getIndexPathForPushedButton(for: sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        friendsNetworkService.loadFriendsFoto(for: friendId) { [weak self] photos, error in
            if let error = error {
                print(error.localizedDescription)
                return
            } else if let photos = photos, let self = self {
                self.dataService.savePhoto(photos, userId: self.friendId)
            }
        }
        
        title = friendName
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        pairTableAndRealm()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        notificationToken?.invalidate()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetailedFoto" {
            let friendFotoController = segue.destination as! DetailedFriendFotoViewController
            friendFotoController.indexToScrollTo = indexPathForPushedPhoto
            friendFotoController.photos = photos
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FotoCell", for: indexPath) as! FriendFotoCell
        guard let photos = photos else { return UICollectionViewCell() }
        
        if let photo = photos[indexPath.row].photo {
            let isLiked = photos[indexPath.row].isliked
            if isLiked == 1 {
                cell.likeCellButton.setImage(UIImage(named: "heartRed"), for: UIControl.State.normal)
                cell.numberOfLikes.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            } else {
                cell.likeCellButton.setImage(UIImage(named: "heartWhite"), for: UIControl.State.normal)
                cell.numberOfLikes.textColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
            }
            
            cell.friendFoto.kf.setImage(with: URL(string: photo))
            cell.numberOfLikes.text = String(photos[indexPath.row].likes)
        }
        
        cell.buttonHandler = {
            if photos[indexPath.row].isliked == 0 {
                self.utilityNetworkService.likeAddDelete(action: .addLike, to: "photo", withId: photos[indexPath.row].id, andOwnerId: self.friendId)
                self.dataService.likeAddDeleteForPhoto(action: .add, primaryKey: photos[indexPath.row].photo!)
            } else {
                self.utilityNetworkService.likeAddDelete(action: .deleteLike, to: "photo", withId: photos[indexPath.row].id, andOwnerId: self.friendId)
                self.dataService.likeAddDeleteForPhoto(action: .delete, primaryKey: photos[indexPath.row].photo!)

            }
        }
        
        return cell
    }
    
    func getIndexPathForPushedButton(for sender: UIButton) -> IndexPath {
        let buttonPosition: CGPoint = sender.convert(CGPoint.zero, to: self.collectionView)
        return self.collectionView.indexPathForItem(at: buttonPosition)!
    }
    
    func pairTableAndRealm(config: Realm.Configuration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)) {
        
        photos = try! Realm(configuration: config).objects(Photo.self).filter("userId == %@", friendId)

        notificationToken = photos?.observe { [weak self] (changes: RealmCollectionChange) in
            guard let collectionView = self?.collectionView else { return }
            switch changes {
            case .initial:
                collectionView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                collectionView.performBatchUpdates({
                    collectionView.deleteItems(at: deletions.map { IndexPath(row: $0, section: 0) })
                    collectionView.insertItems(at: insertions.map { IndexPath(row: $0, section: 0) })
                    collectionView.reloadItems(at: modifications.map { IndexPath(row: $0, section: 0) })
                })
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
}

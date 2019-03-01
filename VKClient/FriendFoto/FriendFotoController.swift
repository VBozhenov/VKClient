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
    var photos: List<Photo>!
    
    let networkService = NetworkService()
    let dataService = DataService()
    var notificationToken: NotificationToken?
    let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)


    
    @IBAction func likeCellButtonPushed(_ sender: UIButton) {
        let indexPath = getIndexPathForPushedButton(for: sender)
        if photos[indexPath.row].isliked == 0 {
            networkService.addLike(to: "photo", withId: photos[indexPath.row].id, andOwnerId: friendId)
            let realm = try! Realm(configuration: config)
            let photo = realm.object(ofType: Photo.self, forPrimaryKey: photos[indexPath.row].id)
            try! realm.write {
                photo?.isliked += 1
                photo?.likes += 1
            }
            
            
        } else {
            networkService.deleteLike(to: "photo", withId: photos[indexPath.row].id, andOwnerId: friendId)
            let realm = try! Realm(configuration: config)
            let photo = realm.object(ofType: Photo.self, forPrimaryKey: photos[indexPath.row].id)
            try! realm.write {
                photo?.isliked -= 1
                photo?.likes -= 1
            }
        }
    }
    
    @IBAction func fotoButtonPushed(_ sender: UIButton) {
        indexPathForPushedPhoto = getIndexPathForPushedButton(for: sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        networkService.loadFriendsFoto(for: friendId) { [weak self] photos, error in
//            if let error = error {
//                print(error.localizedDescription)
//                return
//            } else if let photos = photos, let self = self {
//                self.photos = photos
////                self.dataService.saveData(photos)
//
//                DispatchQueue.main.async {
//                    self.collectionView.reloadData()
//                }
//            }
//        }
        
//        let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
//        let realm = try! Realm(configuration: config)
//        photos = Array(realm.objects(Photo.self)).filter {$0.userId == friendId}
        
        networkService.loadFriendsFoto(for: friendId)
        pairTableAndRealm()
        
        title = friendName
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetailedFoto" {
            let friendFotoController = segue.destination as! DetailedFriendFotoViewController
            friendFotoController.indexToScrollTo = indexPathForPushedPhoto
            friendFotoController.photos = photos
        }
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FotoCell", for: indexPath) as! FriendFotoCell
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
        
        return cell
    }
    
    func getIndexPathForPushedButton(for sender: UIButton) -> IndexPath {
        let buttonPosition: CGPoint = sender.convert(CGPoint.zero, to: self.collectionView)
        return self.collectionView.indexPathForItem(at: buttonPosition)!
    }
    
    func pairTableAndRealm() {
        guard let realm = try? Realm(), let user = realm.object(ofType: User.self, forPrimaryKey: friendId) else { return }
        
        photos = user.photos
        
        notificationToken = photos.observe { [weak self] (changes: RealmCollectionChange) in
            guard let collectionView = self?.collectionView else { return }
            switch changes {
            case .initial:
                collectionView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                collectionView.performBatchUpdates({
                    collectionView.insertItems(at: insertions.map({ IndexPath(row: $0, section: 0) }))
                    collectionView.deleteItems(at: deletions.map({ IndexPath(row: $0, section: 0)}))
                    collectionView.reloadItems(at: modifications.map({ IndexPath(row: $0, section: 0) }))
                }, completion: nil)
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
    
    

    
}

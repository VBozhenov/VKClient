//
//  FriendFotoController.swift
//  VKClient
//
//  Created by Vladimir Bozhenov on 24/12/2018.
//  Copyright © 2018 Vladimir Bozhenov. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

class FriendFotoController: UICollectionViewController {
    
    var friendId = 0
    var photos = [Photo]()
    let networkService = NetworkService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkService.loadFriendsFoto(for: friendId) { [weak self] photos, error in
            if let error = error {
                print(error.localizedDescription)
                return
            } else if let photos = photos, let self = self {
                self.photos = photos
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetailedFoto" {
            let friendFotoController = segue.destination as! DetailedFriendFotoViewController
            friendFotoController.userId = friendId
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
            let isLiked = networkService.isLiked("photo", withId: photos[indexPath.row].id, ownerId: friendId)
            if isLiked {
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
}
